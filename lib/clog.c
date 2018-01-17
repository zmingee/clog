#include <stdio.h>
#include <stdarg.h>
#include <time.h>
#include <string.h>
#include <stdlib.h>
#include "clog.h"

int LOG_LEVEL = DEBUG;

static const char *LEVEL_STRING[] = {
    "CRITICAL", "ERROR", "WARNING", "INFO", "DEBUG"
};

char *print_time() {
    int size = 0;
    time_t t;
    char *buf;
    char timestr[70];

    /* Get current time and convert to ISO 8601 */
    t = time(NULL);
    strftime(timestr, sizeof(timestr), "%FT%T%Z", localtime(&t));

    /* Set end of string */
    timestr[strlen(timestr)] = 0;

    /* Add +2 to size for square braces */
    size = strlen(timestr)+ 1 + 2;
    buf = (char*)malloc(size);

    memset(buf, 0x0, size);
    snprintf(buf, size, "[%s]", timestr);

    return buf;
}

void log_print(char* filename, const char* funcname, int level, int line,
        char *fmt,...) {
    va_list list;
    char *p, *r;
    int e;
    char *formatted_time;

    if (level > LOG_LEVEL)
        return;

    formatted_time = print_time();

    fprintf(stdout, "%s", formatted_time);
    fprintf(stdout, "[%-8s]", LEVEL_STRING[level]);
    fprintf(stdout, "[%s:%s:%d] ", filename, funcname, line);
    va_start(list, fmt);

    for(p = fmt; *p; ++p) {
        if (*p != '%' ) {
            fputc( *p, stdout );
        } else {
            switch ( *++p ) {
                /* string */
                case 's': {
                    r = va_arg(list, char *);
                    fprintf(stdout,"%s", r);
                    continue;
                }
                /* integer */
                case 'd': {
                    e = va_arg(list, int);
                    fprintf(stdout, "%d", e);
                    continue;
                }
                default: {
                    fputc(*p, stdout);
                }
            }
        }
    }
    va_end(list);
    fputc('\n', stdout);

    free(formatted_time);
}


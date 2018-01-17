#include <stdio.h>
#include "minunit.h"
#include "../lib/clog.h"

MU_TEST(test_log_entry) {
    printf("\n---\nRunning: %s\n", __func__);

    LOG_PRINT(CRITICAL, "Test log -\tCRITICAL");
    LOG_PRINT(ERROR, "Test log -\tERROR");
    LOG_PRINT(WARNING, "Test log -\tWARNING");
    LOG_PRINT(INFO, "Test log -\tINFO");
    LOG_PRINT(DEBUG, "Test log -\tDEBUG");
}

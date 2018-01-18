#include <stdio.h>
#include "minunit.h"
#include "test_clog.h"

void test_setup() {}

void test_teardown() {}

MU_TEST_SUITE(test_suite) {
    MU_SUITE_CONFIGURE(&test_setup, &test_teardown);

    /* test_log.h */
    printf("\n==> Testing log.c\n");
    MU_RUN_TEST(test_log_entry);
}

int main() {
    printf(
        "*********************************\n"
        "*** Runing Minunit test suite ***\n"
        "*********************************\n"
    );
    MU_RUN_SUITE(test_suite);
    MU_REPORT();

    return minunit_fail;
}

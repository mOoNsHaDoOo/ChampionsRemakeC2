# Runs ilbm_test and compares the output with scripts/check_ilbm.py.
execute_process(COMMAND ${TEST} ${FILE} ${OUT} RESULT_VARIABLE rc)
if(NOT rc EQUAL 0)
    message(FATAL_ERROR "ilbm_test: ${rc}")
endif()
execute_process(COMMAND ${PYTHON} ${CHECK} ${FILE} ${OUT} RESULT_VARIABLE rc)
if(NOT rc EQUAL 0)
    message(FATAL_ERROR "check_ilbm.py: differences")
endif()

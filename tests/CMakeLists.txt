macro(add_chemkit_python_test test_name test_script)
  add_test(${test_name} ${PYTHON_EXECUTABLE} ${test_script})
  set_tests_properties(${test_name} PROPERTIES ENVIRONMENT "PYTHONPATH=${CMAKE_BINARY_DIR}/src/chemkit/")
endmacro(add_chemkit_python_test)

add_subdirectory(chemkit)

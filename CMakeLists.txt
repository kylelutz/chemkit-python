cmake_minimum_required(VERSION 2.8)

project(chemkit-python)

set(CMAKE_MODULE_PATH ${chemkit-python_SOURCE_DIR}/cmake)

set(CMAKE_BUILD_TYPE Release)

# find cython
find_program(CYTHON cython REQUIRED)

# find python interpreter
find_package(PythonInterp REQUIRED)

# source directory
add_subdirectory(src)

# testing
enable_testing()
add_subdirectory(tests)

# uninstall target
configure_file(
	"${CMAKE_MODULE_PATH}/cmake_uninstall.cmake.in"
	"${CMAKE_CURRENT_BINARY_DIR}/cmake_uninstall.cmake"
	IMMEDIATE @ONLY)

add_custom_target(uninstall
	COMMAND ${CMAKE_COMMAND} -P ${CMAKE_CURRENT_BINARY_DIR}/cmake_uninstall.cmake)


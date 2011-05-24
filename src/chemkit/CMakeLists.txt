# find python
find_package(PythonLibs REQUIRED)
include_directories(${PYTHON_INCLUDE_PATH})

# find boost
find_package(Boost REQUIRED)
include_directories(${Boost_INCLUDE_DIRS})

# find eigen3
find_package(Eigen3 REQUIRED)
include_directories(${EIGEN3_INCLUDE_DIR})

# find qt
find_package(Qt4 4.6 COMPONENTS QtCore REQUIRED)
set(QT_DONT_USE_QTGUI TRUE)
include(${QT_USE_FILE})

set(SOURCES
  atom.pxd
  atom.pxi
  bond.pxd
  bond.pxi
  chemkit.pyx
  element.pxd
  element.pxi
  forcefield.pxd
  forcefield.pxi
  fragment.pxd
  fragment.pxi
  lineformat.pxd
  lineformat.pxi
  moleculefile.pxd
  moleculefile.pxi
  molecule.pxd
  molecule.pxi
  point3.pxd
  point3.pxi
  ring.pxd
  ring.pxi
  vector3.pxd
  vector3.pxi
)

# run cython
add_custom_command(OUTPUT chemkit.cpp
                   COMMAND ${CYTHON} --cplus -o ${CMAKE_CURRENT_BINARY_DIR}/chemkit.cpp
                           ${CMAKE_CURRENT_SOURCE_DIR}/chemkit.pyx
                   DEPENDS ${SOURCES})

# build library
add_library(chemkit-python SHARED chemkit.cpp)
set_target_properties(chemkit-python PROPERTIES OUTPUT_NAME "chemkit" PREFIX "")
target_link_libraries(chemkit-python chemkit)

# find python site-packages directory for installation
execute_process(COMMAND ${PYTHON_EXECUTABLE} 
                -c "from distutils.sysconfig import get_python_lib; print get_python_lib()" 
                OUTPUT_VARIABLE PYTHON_SITE_PACKAGES OUTPUT_STRIP_TRAILING_WHITESPACE)

# install target
install(TARGETS chemkit-python DESTINATION ${PYTHON_SITE_PACKAGES})

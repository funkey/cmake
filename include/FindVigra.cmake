# This module finds an installed Vigra package.
#
# It sets the following variables:
#  Vigra_FOUND         - True, if vigra was found.
#  Vigra_INCLUDE_DIR   - The include directory.
#  Vigra_IMPEX_LIBRARY - Vigra impex library.
#  Vigra_LIBRARIES     - All vigra libraries.

set (Vigra_BUILD_DIR "" CACHE PATH "The Vigra build directory")

if (Vigra_BUILD_DIR)

  message(STATUS "Reading ${Vigra_BUILD_DIR}/VigraConfig.cmake")

  # this reads Vigra_INCLUDE_DIRS
  include(${Vigra_BUILD_DIR}/VigraConfig.cmake)

  set(Vigra_INCLUDE_DIR ${Vigra_INCLUDE_DIRS})

  message(STATUS "Searching for vigra libs in ${Vigra_BUILD_DIR}")

  find_library(Vigra_IMPEX_LIBRARY vigraimpex     ${Vigra_BUILD_DIR}/src/impex)

  message(STATUS "Set Vigra_INCLUDE_DIR to ${Vigra_INCLUDE_DIR}")
  message(STATUS "Set Vigra_IMPEX_LIBRARY to ${Vigra_IMPEX_LIBRARY}")

else()

  message(STATUS "Searching for system installation")

  find_path(Vigra_INCLUDE_DIR vigra/matrix.hxx)
  find_library(Vigra_IMPEX_LIBRARY vigraimpex)

endif()

if (Vigra_INCLUDE_DIR AND Vigra_IMPEX_LIBRARY)
  set(Vigra_FOUND true)
  set(Vigra_LIBRARIES ${Vigra_IMPEX_LIBRARY})
else()
  set(Vigra_FOUND false)
endif()

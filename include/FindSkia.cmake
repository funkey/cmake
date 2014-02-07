# CMake module to find the Skia library and include files in a skia build directory.
#
# Provides:
#
#   SKIA_FOUND
#   Skia_INCLUDE_DIR
#   Skia_LIBRARY

SET(Skia_BUILD_DIR "" CACHE PATH "Skia build directory")

FIND_PATH(Skia_INCLUDE_DIR
  core/SkCanvas.h
  HINTS ${Skia_BUILD_DIR}/include
  HINTS ${Skia_BUILD_DIR}/trunk/include)

FIND_LIBRARY(Skia_LIBRARY
  skia
  PATH ${Skia_BUILD_DIR}/out/Release
  PATH ${Skia_BUILD_DIR}/trunk/out/Release)

INCLUDE(FindPackageHandleStandardArgs)
FIND_PACKAGE_HANDLE_STANDARD_ARGS(Skia DEFAULT_MSG Skia_LIBRARY Skia_INCLUDE_DIR)

MARK_AS_ADVANCED(Skia_INCLUDE_DIR Skia_LIBRARY)

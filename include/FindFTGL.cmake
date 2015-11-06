#
# Find libftgl
#

# This module defines
# FTGL_FOUND
# FTGL_INCLUDE_DIR
# FTGL_LIBRARY

set(FTGL_FOUND 0)

find_path(FTGL_INCLUDE_DIR ftgl.h PATH_SUFFIXES FTGL )
find_library(FTGL_LIBRARY ftgl)

if(FTGL_INCLUDE_DIR)
  if(FTGL_LIBRARY)
    set(FTGL_FOUND 1)
  endif()
endif()

mark_as_advanced(FTGL_FOUND FTGL_INCLUDE_DIR FTGL_LIBRARY)

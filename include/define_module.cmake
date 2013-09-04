include(${CMAKE_SOURCE_DIR}/cmake/include/third_party.cmake)

# Takes a list of module names and appends to three lists:
#
#   include_dirs   List of all transitive include directories.
#   link_modules   List of transitive module dependencies.
#   link_3rd_party List of trassitive 3rd party dependencies.
#
macro(module_link_modules links)

  foreach(link ${links})

    find_3rd_party(${link})

    if(found_3rd_party)

      list(APPEND include_dirs "${include_3rd_party}")

    else()

      # link must be a module

      # link against this module
      # TODO: replace hard-coded module path with module path read from ${link}.path
      list(APPEND include_dirs ${CMAKE_SOURCE_DIR}/modules/${module})
      list(APPEND link_modules ${link})

      if(NOT EXISTS ${PROJECT_BINARY_DIR}/${link}.link_modules)
        message("module ${link} does not exist -- did you define the modules in the correct order?")
      endif()

      # include module include dependencies
      file(READ ${PROJECT_BINARY_DIR}/${link}.include_dirs module_include_dirs)
      list(APPEND include_dirs "${module_include_dirs}")

      # link against module dependencies of module
      file(READ ${PROJECT_BINARY_DIR}/${link}.link_modules module_dependencies)
      module_link_modules("${module_dependencies}")

      # link against 3rd party dependencies of module
      file(READ ${PROJECT_BINARY_DIR}/${link}.link_3rd 3rd_party_dependencies)
      list(APPEND link_3rd_party ${3rd_party_dependencies})

    endif()

  endforeach()

  list(REMOVE_DUPLICATES include_dirs)
  list(REMOVE_DUPLICATES link_modules)
  list(REMOVE_DUPLICATES link_3rd_party)

endmacro()

macro(define_module name)

  ############
  # defaults #
  ############

  set(type "BINARY")
  file(GLOB_RECURSE sources ${CMAKE_CURRENT_SOURCE_DIR}/*.cpp)
  set(includes "")
  set(links    "")

  ##############################
  # process optional arguments #
  ##############################

  set(read_sources  FALSE)
  set(read_includes FALSE)
  set(read_links    FALSE)

  set(keywords "BINARY;LIBRARY;SOURCES;INCLUDES;LINKS")

  foreach(arg ${ARGN})

    list(FIND keywords ${arg} index)
    if (index STRLESS 0)
      set(is_keyword FALSE)
    else()
      set(is_keyword TRUE)
    endif()

    if(is_keyword)

      if(arg MATCHES "BINARY" OR arg MATCHES "LIBRARY")
        set(type ${arg})
      elseif(arg MATCHES "SOURCES")
        set(read_sources  TRUE)
        set(read_includes FALSE)
        set(read_links    FALSE)
      elseif(arg MATCHES "INCLUDES")
        set(read_sources  FALSE)
        set(read_includes TRUE)
        set(read_links    FALSE)
      elseif(arg MATCHES "LINKS")
        set(read_sources  FALSE)
        set(read_includes FALSE)
        set(read_links    TRUE)
      endif()

    else()

      if(read_sources)
        set(sources ${arg})
        set(read_sources FALSE)
      elseif(read_includes)
        list(APPEND includes ${arg})
      elseif(read_links)
        list(APPEND links ${arg})
      endif()

    endif()

  endforeach()

  ########################
  # prepare dependencies #
  ########################

  message("")
  message("creating target '${name}'")
  message("   includes    : '${includes}'")
  message("   links       : '${links}'")

  set(include_dirs   "")
  set(link_modules   "")
  set(link_3rd_party "")

  ####################
  # process includes #
  ####################

  foreach(module ${includes})
    list(APPEND include_dirs ${CMAKE_SOURCE_DIR}/modules/${module})
  endforeach()

  #################
  # process links #
  #################
  module_link_modules("${links}")

  #################
  # create target #
  #################

  if(type MATCHES "BINARY")
    add_executable(${name} ${sources})
  else()
    add_library(${name} ${sources})
  endif()

  include_directories(${include_dirs})
  target_link_libraries(${name} ${link_modules} ${link_3rd_party})

  message("   include dirs: '${include_dirs}'")
  message("   link modules: '${link_modules}'")
  message("   link 3rd    : '${link_3rd_party}'")
  message("")

  file(WRITE ${PROJECT_BINARY_DIR}/${name}.include_dirs "${include_dirs}")
  file(WRITE ${PROJECT_BINARY_DIR}/${name}.link_modules "${link_modules}")
  file(WRITE ${PROJECT_BINARY_DIR}/${name}.link_3rd     "${link_3rd_party}")

endmacro()

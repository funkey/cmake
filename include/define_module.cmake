# Provides the macro 'define_module' to define modules. Usage:
#
#   define_module(
#       <name of module>
#       [BINARY|LIBRARY|STATIC_LIBRARY|CUDA_LIBRARY|HEADER]
#       [SOURCES <source files>]
#       [LINKS <other modules and 3rd parties>]
#       [INCLUDES <other modules or directories>])
#
#   name of module
#
#     a unique name for your model
#
#   BINARY, [STATIC_,CUDA_]LIBRARY, OBJECT, or HEADER
#
#     whether the module shall be compiled into a shared or static library, a
#     cmake object target or binary (default: BINARY); for HEADER, no target is
#     created, just the dependencies are tracked
#
#   SOURCES
#
#     the source files for the module (default: all *.cpp files in all subdirectories)
#
#   LINKS
#
#     link dependencies for this module (can be other module names or symbolic
#     names for third party libraries, as defined in third_party.cmake)
#
#   INCLUDES
#
#     include directories that are needed by other modules to compile against
#     this module (besides the ones that are already provided by the linked
#     modules)
#
#
# Example:
#
#   define_module(flitzblitz LIBRARY LINKS sonic light boost INCLUDES ${CMAKE_CURRENT_SOURCE_DIR}/include)
#
#   ...defines a library 'flitzblitz' that links against the modules 'sonic',
#   'light', and 'boost' (where 'boost' is handled as a third party module, see
#   third_party.cmake) and tells other modules, that if they want to compile
#   against it, they need to include the subdirectory './include'.
#
# Initial version by Julien Martel (jmartel@ini.ch).
# Modified by Jan Funke (funke@ini.ch)

include(${CMAKE_CURRENT_LIST_DIR}/third_party.cmake)

# Takes a list of module names and appends to six lists:
#
#   include_dirs        List of all transitive include directories.
#   link_modules        List of transitive module dependencies.
#   link_3rd_party_dirs List of all transitive link directories.
#   link_3rd_party      List of trassitive 3rd party dependencies.
#   misc_targets        List of misc targets like external projects.
#   object_targets      List of cmake object targets.
#
macro(module_link_modules links)

  foreach(link ${links})

    find_3rd_party(${link})

    if(found_3rd_party)

      list(APPEND include_dirs "${include_3rd_party}")

    else()

      # link must be a module

      if(NOT EXISTS ${PROJECT_BINARY_DIR}/${link}.path)
        message("module ${link} does not exist -- did you define the modules in the correct order?")
      endif()

      # link against this module, if it is a library
      file(READ ${PROJECT_BINARY_DIR}/${link}.type module_type)
      if(NOT module_type MATCHES "HEADER" AND NOT module_type MATCHES "OBJECT")
        list(APPEND link_modules ${link})
      endif()

      # add it to sources as object target, if it is an object target
      if(module_type MATCHES "OBJECT")
        list(APPEND object_targets $<TARGET_OBJECTS:${link}>)
      endif()

      # include module include dependencies
      file(READ ${PROJECT_BINARY_DIR}/${link}.include_dirs module_include_dirs)
      list(APPEND include_dirs "${module_include_dirs}")

      # link against module dependencies of module
      file(READ ${PROJECT_BINARY_DIR}/${link}.link_modules module_dependencies)
      module_link_modules("${module_dependencies}")

      # link against 3rd party dependencies of module
      file(READ ${PROJECT_BINARY_DIR}/${link}.link_3rd_dirs 3rd_party_dependencies_dirs)
      list(APPEND link_3rd_party_dirs ${3rd_party_dependencies_dirs})
      file(READ ${PROJECT_BINARY_DIR}/${link}.link_3rd 3rd_party_dependencies)
      list(APPEND link_3rd_party ${3rd_party_dependencies})
      file(READ ${PROJECT_BINARY_DIR}/${link}.misc_targets misc_target_dependencies)
      list(APPEND misc_targets ${misc_target_dependencies})
      file(READ ${PROJECT_BINARY_DIR}/${link}.object_targets object_target_dependencies)
      list(APPEND object_targets ${object_target_dependencies})

    endif()

  endforeach()

  list(REMOVE_DUPLICATES include_dirs)
  list(REMOVE_DUPLICATES link_modules)
  list(REMOVE_DUPLICATES link_3rd_party_dirs)
  list(REMOVE_DUPLICATES link_3rd_party)
  list(REMOVE_DUPLICATES misc_targets)
  list(REMOVE_DUPLICATES object_targets)
  list(REMOVE_ITEM link_3rd_party "debug" "optimized")

endmacro()

# Takes a list of module names and appends to the list:
#
#   include_dirs   List of all transitive include directories.
#
macro(module_include_modules links)

  foreach(link ${links})

    find_3rd_party(${link})

    if(found_3rd_party)

      list(APPEND include_dirs "${include_3rd_party}")

    else()

      if(EXISTS ${link})

        # link is a directory

        list(APPEND include_dirs ${link})

      else()

        # link must be a module

        if(NOT EXISTS ${PROJECT_BINARY_DIR}/${link}.path)
          message("module ${link} does not exist -- did you define the modules in the correct order?")
        endif()

        # link against this module
        #file(READ ${PROJECT_BINARY_DIR}/${link}.path module_path)
        #list(APPEND include_dirs ${module_path})

        # include module include dependencies
        file(READ ${PROJECT_BINARY_DIR}/${link}.include_dirs module_include_dirs)
        list(APPEND include_dirs "${module_include_dirs}")

      endif()

    endif()

  endforeach()

  list(REMOVE_DUPLICATES include_dirs)

endmacro()


macro(define_module name)

  ############
  # defaults #
  ############

  set(type "BINARY")
  file(GLOB_RECURSE sources ${CMAKE_CURRENT_SOURCE_DIR}/*.cpp)
  set(includes ${CMAKE_CURRENT_SOURCE_DIR})
  set(links    "")

  ##############################
  # process optional arguments #
  ##############################

  set(read_sources  FALSE)
  set(read_includes FALSE)
  set(read_links    FALSE)

  set(keywords "BINARY;LIBRARY;STATIC_LIBRARY;CUDA_LIBRARY;OBJECT;HEADER;SOURCES;INCLUDES;LINKS")

  foreach(arg ${ARGN})

    list(FIND keywords ${arg} index)
    if (index STRLESS 0)
      set(is_keyword FALSE)
    else()
      set(is_keyword TRUE)
    endif()

    if(is_keyword)

      if(arg MATCHES "BINARY" OR arg MATCHES "LIBRARY" OR arg MATCHES "STATIC_LIBRARY" OR arg MATCHES "CUDA_LIBRARY" OR arg MATCHES "OBJECT" OR arg MATCHES "HEADER")
        set(type ${arg})
      elseif(arg MATCHES "SOURCES")
        set(sources "")
        set(read_sources  TRUE)
        set(read_includes FALSE)
        set(read_links    FALSE)
      elseif(arg MATCHES "INCLUDES")
        set(includes "")
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
        list(APPEND sources ${arg})
      elseif(read_includes)
        list(APPEND includes ${arg})
      elseif(read_links)
        list(APPEND links ${arg})
      else()
        message(FATAL_ERROR "Unknown argument ${arg}")
      endif()

    endif()

  endforeach()

  ########################
  # prepare dependencies #
  ########################

  set(include_dirs        "")
  set(link_modules        "")
  set(link_3rd_party_dirs "")
  set(link_3rd_party      "")
  set(misc_targets        "")
  set(object_targets      "")

  ####################
  # process includes #
  ####################

  module_include_modules("${includes}")

  #################
  # process links #
  #################

  module_link_modules("${links}")

  #################
  # create target #
  #################

  include_directories(${include_dirs})
  link_directories(${link_3rd_party_dirs})

  if(type MATCHES "HEADER")

    #add_custom_target(${name})
    #message("    this is a header only module")

  else()

    if(type MATCHES "BINARY")
      add_executable(${name} ${sources} ${object_targets})
    elseif(type MATCHES "STATIC_LIBRARY")
      add_library(${name} ${sources} ${object_targets})
    elseif(type MATCHES "CUDA_LIBRARY")
      cuda_add_library(${name} ${sources} ${object_targets})
    elseif(type MATCHES "LIBRARY")
      add_library(${name} SHARED ${sources} ${object_targets})
    elseif(type MATCHES "OBJECT")
      add_library(${name} OBJECT ${sources})
    endif()

    if (NOT type MATCHES "OBJECT")
      target_link_libraries(${name} ${link_modules} ${link_3rd_party} -lz)
    endif()

    if (NOT "${misc_targets}" STREQUAL "")
      add_dependencies(${name} ${misc_targets})
    endif()

  endif()

  file(WRITE ${PROJECT_BINARY_DIR}/${name}.include_dirs   "${include_dirs}")
  file(WRITE ${PROJECT_BINARY_DIR}/${name}.link_modules   "${link_modules}")
  file(WRITE ${PROJECT_BINARY_DIR}/${name}.link_3rd_dirs  "${link_3rd_party_dirs}")
  file(WRITE ${PROJECT_BINARY_DIR}/${name}.link_3rd       "${link_3rd_party}")
  file(WRITE ${PROJECT_BINARY_DIR}/${name}.misc_targets   "${misc_targets}")
  file(WRITE ${PROJECT_BINARY_DIR}/${name}.object_targets "${object_targets}")
  file(WRITE ${PROJECT_BINARY_DIR}/${name}.path           "${CMAKE_CURRENT_SOURCE_DIR}")
  file(WRITE ${PROJECT_BINARY_DIR}/${name}.type           "${type}")

endmacro()

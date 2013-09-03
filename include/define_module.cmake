include(${CMAKE_SOURCE_DIR}/cmake/include/third_party.cmake)

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

  ####################
  # process includes #
  ####################

  foreach(module ${includes})
    include_directories(${CMAKE_SOURCE_DIR}/modules/${module})
  endforeach()

  #################
  # process links #
  #################

  foreach(link ${links})

    find_third_party(${link})

    if(NOT found_third_party)

      # link must be a module
      include_directories(${CMAKE_SOURCE_DIR}/modules/${module})
      list(APPEND link_modules ${link})

    endif()

  endforeach()

  #################
  # create target #
  #################

  if(type MATCHES "BINARY")
    add_executable(${name} ${sources})
  else()
    add_library(${name} ${sources})
  endif()

  target_link_libraries(${name} ${link_modules} ${link_3rd_party})

  message("created target '${name}'")
  message("   link modules: '${link_modules}'")
  message("   link 3rd    : '${link_3rd_party}'")

endmacro()

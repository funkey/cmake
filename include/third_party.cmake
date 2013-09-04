#  Macro to find a 3rd party module by its name. If found, appends to the following lists:
#
#   include_3rd_party List of include directories for the requrested module.
#   link_3rd_party    List of link dependencies for the requested module.
#
#  Whether the module was found is reported in:
#
#   found_3rd_party   TRUE, if the module was found.
#
macro(find_3rd_party name)

  set(module ${name})
  set(found_3rd_party TRUE)

  if(module MATCHES "boost")

    find_package(Boost 1.42 COMPONENTS filesystem program_options serialization signals system thread timer REQUIRED)
    if(Boost_FOUND)
      list(APPEND include_3rd_party ${Boost_INCLUDE_DIR})
      list(APPEND link_3rd_party ${Boost_LIBRARIES})
      message(STATUS "Boost found.")
    else()
      message(STATUS "Boost *NOT* found.")
    endif()

  elseif(module MATCHES "x11")

    find_package(X11 REQUIRED)
    if (X11_FOUND)
      list(APPEND include_3rd_party ${X11_INCLUDE_DIR})
      list(APPEND link_3rd_party ${X11_X11_LIB} ${X11_Xrandr_LIB} ${X11_Xinput_LIB})
      message(STATUS "X11 found")
    else()
      message(STATUS "X11 *NOT* found")
    endif()

  elseif(module MATCHES "xcb")

    find_package(XCB REQUIRED)
    if (XCB_FOUND)
      list(APPEND include_3rd_party ${XCB_INCLUDE_DIR})
      list(APPEND link_3rd_party ${XCB_LIBRARIES})
      message(STATUS "XCB found.")
    else()
      message(STATUS "XCB *NOT* found.")
    endif()

  elseif(module MATCHES "opengl")

    find_package(OpenGL)
    if(OPENGL_FOUND)
      list(APPEND link_3rd_party ${OPENGL_LIBRARY})
      message(STATUS "OpenGL found.")
    else()
      message(STATUS "OpenGL *NOT* found.")
    endif()

  elseif(module MATCHES "glew")

    find_package(GLEW)
    if (GLEW_FOUND)
      list(APPEND include_3rd_party ${GLEW_INCLUDE_DIR})
      list(APPEND link_3rd_party ${GLEW_LIBRARY})
      message(STATUS "GLEW found.")
    else()
      message(STATUS "GLEW *NOT* found.")
    endif()

  elseif(module MATCHES "glut")

    find_package(GLUT)
    if (GLUT_FOUND)
      list(APPEND include_3rd_party ${GLUT_INCLUDE_DIR})
      list(APPEND link_3rd_party ${GLUT_LIBRARIES})
      message(STATUS "GLUT found.")
    else()
      message(STATUS "GLUT *NOT* found.")
    endif()

  elseif(module MATCHES "vigra")

    find_package(Vigra REQUIRED)
    if (Vigra_FOUND)
      list(APPEND include_3rd_party ${Vigra_INCLUDE_DIR})
      list(APPEND link_3rd_party ${Vigra_LIBRARIES})
      message(STATUS "Vigra found.")
      set(HAVE_VIGRA 1 CACHE INTERNAL "")
    else()
      message(STATUS "Vigra *NOT* found.")
      set(HAVE_VIGRA 0 CACHE INTERNAL "")
    endif()

  elseif(module MATCHES "hdf5")

    find_package(HDF5 COMPONENTS CXX HL)
    if (HDF5_FOUND)
      list(APPEND include_3rd_party "${HDF5_INCLUDE_DIRS}")
      list(APPEND link_3rd_party ${HDF5_LIBRARIES})
      message(STATUS "HDF5 found.")
      set(HAVE_HDF5 1 CACHE INTERNAL "")
    else()
      # try to find older version without HL
      find_package(HDF5 COMPONENTS CXX)
      if (HDF5_FOUND)
        list(APPEND include_3rd_party "${HDF5_INCLUDE_DIRS}")
        list(APPEND link_3rd_party ${HDF5_LIBRARIES})
        message(STATUS "HDF5 found.")
        set(HAVE_HDF5 1 CACHE INTERNAL "")
      else()
        message(STATUS "HDF5 *NOT* found.")
        set(HAVE_HDF5 0 CACHE INTERNAL "")
      endif()
    endif()

  elseif(module MATCHES "cairo")

    find_package(Cairo)
    if(Cairo_FOUND)
      list(APPEND include_3rd_party ${Cairo_INCLUDE_DIR})
      list(APPEND link_3rd_party ${Cairo_LIBRARY})
      message(STATUS "Cairo found.")
      set(HAVE_CAIRO 1 CACHE INTERNAL "")
    else()
      message(STATUS "Cairo *NOT* found.")
      set(HAVE_CAIRO 0 CACHE INTERNAL "")
    endif()

  elseif(module MATCHES "png")

    find_package(PNG)
    if(PNG_FOUND)
      message(STATUS "PNG found.")
      list(APPEND link_3rd_party ${PNG_LIBRARY})
      set(HAVE_PNG 1 CACHE INTERNAL "")
    else()
      message(STATUS "PNG *NOT* found.")
      set(HAVE_PNG 0 CACHE INTERNAL "")
    endif()

  elseif(module MATCHES "doxygen")

    find_package(Doxygen)
    if (DOXYGEN_FOUND)
      configure_file(${PROJECT_SOURCE_DIR}/cmake/doxygen.in ${PROJECT_BINARY_DIR}/doxygen.conf)
      add_custom_target(
          primdoc
          ${DOXYGEN_EXECUTABLE} ${PROJECT_BINARY_DIR}/doxygen.conf
          WORKING_DIRECTORY ${PROJECT_BINARY_DIR}
          COMMENT "Generating Doxygen documentation"
          VERBATIM)
      message(STATUS "Doxygen found.")
    else()
      message(STATUS "Doxygen *NOT* found.")
    endif()

  else()

    set(found_3rd_party FALSE)

  endif()

endmacro()

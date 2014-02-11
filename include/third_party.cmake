#  Macro to find a 3rd party module by its name. If found, appends to the following lists:
#
#   include_3rd_party   List of include directories for the requrested module.
#   link_3rd_party_dirs List of link directories for the requested module.
#   link_3rd_party      List of link dependencies for the requested module.
#   misc_targets        List of misc targets for the requested module (for
#                       external projects).
#
#  Whether the module was found is reported in:
#
#   found_3rd_party   TRUE, if the module was found.
#
set(CMAKE_MODULE_PATH ${CMAKE_CURRENT_LIST_DIR})

macro(find_3rd_party name)

  set(module ${name})
  set(found_3rd_party TRUE)

  if(module MATCHES "^boost$")

    find_package(Boost 1.42 COMPONENTS date_time filesystem program_options serialization signals system thread timer REQUIRED)
    if(Boost_FOUND)
      list(APPEND include_3rd_party ${Boost_INCLUDE_DIR})
      list(APPEND link_3rd_party ${Boost_LIBRARIES})
      message(STATUS "Boost found.")
    else()
      message(STATUS "Boost *NOT* found.")
    endif()

  elseif(module MATCHES "boost-python")

    find_package(Boost 1.42 COMPONENTS python REQUIRED)
    if(Boost_FOUND)
      list(APPEND include_3rd_party ${Boost_INCLUDE_DIR})
      list(APPEND link_3rd_party ${Boost_LIBRARIES})
      message(STATUS "boost-python found.")
    else()
      message(STATUS "boost-python *NOT* found.")
    endif()

    find_package(PythonLibs REQUIRED)
    if(PYTHONLIBS_FOUND)
      list(APPEND include_3rd_party "${PYTHON_INCLUDE_DIRS}")
      list(APPEND link_3rd_party ${PYTHON_LIBRARIES})
      message(STATUS "python found.")
    else()
      message(STATUS "python *NOT* found.")
    endif()

  elseif(module MATCHES "lapack")

    find_package(LAPACK REQUIRED)
    if (LAPACK_FOUND)
      list(APPEND link_3rd_party "${LAPACK_LIBRARIES}")
      message(STATUS "LAPACK found")
    else()
      message(STATUS "LAPACK *NOT* found")
    endif()

  elseif(module MATCHES "cplex")

    find_package(CPLEX)
    if(CPLEX_FOUND)
      list(APPEND include_3rd_party "${CPLEX_INCLUDE_DIRS}")
      list(APPEND link_3rd_party "${CPLEX_LIBRARIES}")
      add_definitions(-DIL_STD)
      message(STATUS "CPLEX found")
      set(HAVE_CPLEX 1 CACHE INTERNAL "")
    else()
      message(STATUS "CPLEX not found")
      set(HAVE_CPLEX 0 CACHE INTERNAL "")
    endif()

  elseif(module MATCHES "gurobi")

    find_package(Gurobi)
    if(GUROBI_FOUND)
      list(APPEND include_3rd_party "${Gurobi_INCLUDE_DIRS}")
      list(APPEND link_3rd_party "${Gurobi_LIBRARIES}")
      list(APPEND link_3rd_party_dirs ${Gurobi_LIBRARY_DIR})
      set(HAVE_GUROBI 1 CACHE INTERNAL "")
      message(STATUS "Gurobi found " ${Gurobi_LIBRARY_DIR})
    else()
      message(STATUS "Gurobi *NOT* found")
      set(HAVE_GUROBI 0 CACHE INTERNAL "")
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

  elseif(module MATCHES "^vigra$")

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

  elseif(module MATCHES "vigra-git")

    # check if vigra-git was already added as an external project
    if (NOT TARGET vigra-git)

      include(ExternalProject)

      message(STATUS "vigra git version requested -- will download and build it on demand.")
      ExternalProject_Add(
        vigra-git
        GIT_REPOSITORY http://github.com/ukoethe/vigra.git
        GIT_TAG 7a492ea284ec3e4f78a48f1a8a939a3d9c749f47
        UPDATE_COMMAND ""
        PATCH_COMMAND ""
        CMAKE_ARGS -DAUTOBUILD_TESTS:BOOL=OFF -DVIGRA_STATIC_LIB:BOOL=ON -DWITH_VIGRANUMPY:BOOL=OFF
        INSTALL_COMMAND ""
      )
      ExternalProject_Get_Property(vigra-git SOURCE_DIR)
      ExternalProject_Get_Property(vigra-git BINARY_DIR)
      set(Vigra_INCLUDE_DIR ${SOURCE_DIR}/include)
      set(Vigra_LIBRARIES "${BINARY_DIR}/src/impex/libvigraimpex.a")
      list(APPEND include_3rd_party ${Vigra_INCLUDE_DIR})
      list(APPEND link_3rd_party ${Vigra_LIBRARIES})
      list(APPEND misc_targets vigra-git)

      find_3rd_party(png)
      find_3rd_party(jpeg)
      find_3rd_party(tiff)

      set(HAVE_VIGRA 1 CACHE INTERNAL "")

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

  elseif(module MATCHES "skia")

    find_package(Skia)
    if (SKIA_FOUND)
      message(STATUS "Skia found.")
      set(HAVE_SKIA 1)
    else()
      message(STATUS "Skia not found -- will download and build it on demand.")
      include(ExternalProject)
      ExternalProject_Add(
        skia
        GIT_REPOSITORY gitolite@lego.slyip.net:fun/skia
        GIT_TAG a8362292a0095f44c8f63d549a4cad05069d20e4
        UPDATE_COMMAND ""
        PATCH_COMMAND ""
        INSTALL_COMMAND ""
      )
      ExternalProject_Get_Property(skia SOURCE_DIR)
      set(Skia_INCLUDE_DIR ${SOURCE_DIR}/include)
      set(Skia_LIBRARY ${SOURCE_DIR}/out/Release/libskia.a)
      set(HAVE_SKIA 1)
      set(OWN_SKIA 1)
    endif()
    list(APPEND include_3rd_party ${Skia_INCLUDE_DIR}/config)
    list(APPEND include_3rd_party ${Skia_INCLUDE_DIR}/core)
    list(APPEND include_3rd_party ${Skia_INCLUDE_DIR}/effects)
    list(APPEND include_3rd_party ${Skia_INCLUDE_DIR}/pdf)
    list(APPEND link_3rd_party ${Skia_LIBRARY})
    list(APPEND misc_targets skia)

  elseif(module MATCHES "freetype")

    find_package(Freetype)
    if (FREETYPE_FOUND)
      list(APPEND link_3rd_party ${FREETYPE_LIBRARIES})
      list(APPEND link_3rd_party "-lfontconfig")
      message(STATUS "Freetype found.")
    else()
      message(STATUS "Freetype *NOT* found.")
    endif()

  elseif(module MATCHES "png")

    find_package(PNG)
    if(PNG_FOUND)
      message(STATUS "PNG found.")
      list(APPEND link_3rd_party ${PNG_LIBRARY})
      list(APPEND include_3rd_party "${PNG_INCLUDE_DIRS}")
      set(HAVE_PNG 1 CACHE INTERNAL "")
    else()
      message(STATUS "PNG *NOT* found.")
      set(HAVE_PNG 0 CACHE INTERNAL "")
    endif()

  elseif(module MATCHES "jpeg")

    find_package(JPEG)
    if(JPEG_FOUND)
      message(STATUS "JPEG found.")
      list(APPEND link_3rd_party "${JPEG_LIBRARIES}")
      list(APPEND include_3rd_party "${JPEG_INCLUDE_DIRS}")
      set(HAVE_JPEG 1 CACHE INTERNAL "")
    else()
      message(STATUS "JPEG *NOT* found.")
      set(HAVE_JPEG 0 CACHE INTERNAL "")
    endif()

  elseif(module MATCHES "tiff")

    find_package(TIFF)
    if(TIFF_FOUND)
      message(STATUS "TIFF found.")
      list(APPEND link_3rd_party "${TIFF_LIBRARIES}")
      list(APPEND include_3rd_party "${TIFF_INCLUDE_DIRS}")
      set(HAVE_TIFF 1 CACHE INTERNAL "")
    else()
      message(STATUS "TIFF *NOT* found.")
      set(HAVE_TIFF 0 CACHE INTERNAL "")
    endif()

  elseif(module MATCHES "cuda")

    find_package(CUDA)
    if (CUDA_FOUND)
      message(STATUS "CUDA found")
      # workaround for otherwise empty -I argument to nvcc
      set(CUDA_INCLUDE_DIRS ${CUDA_TOOLKIT_INCLUDE} CACHE STRING "")
      ################
      # 64-bit linux #
      ################
      find_library(CUDA_CUTIL_LIBRARY cutil_x86_64 PATHS "${CUDA_SDK_ROOT_DIR}/C/lib" "${CUDA_SDK_ROOT_DIR}/CUDALibraries/common/lib")
      find_library(CUDA_SHRUTIL_LIBRARY shrutil_x86_64 "${CUDA_SDK_ROOT_DIR}/shared/lib")
      list(APPEND link_3rd_party ${CUDA_CUDART_LIBRARY})
      list(APPEND link_3rd_party cuda)
      list(APPEND link_3rd_party ${CUDA_CUTIL_LIBRARY})
      list(APPEND link_3rd_party ${CUDA_SHRUTIL_LIBRARY})
      list(APPEND include_3rd_party ${CUDA_SDK_ROOT_DIR}/C/common/inc)
      list(APPEND include_3rd_party ${CUDA_SDK_ROOT_DIR}/shared/inc)
      list(APPEND include_3rd_party ${CUDA_TOOLKIT_INCLUDE})
      set(CUDA_NVCC_FLAGS         "-arch compute_20 -DNDEBUG" CACHE INTERNAL "The NVCC flags")
      set(CUDA_NVCC_FLAGS_DEBUG   "-DDEBUG -g -G"             CACHE INTERNAL "The NVCC debug flags")
      set(CUDA_NVCC_FLAGS_RELEASE "-arch compute_20 -DNDEBUG" CACHE INTERNAL "The NVCC release flags")
      set(HAVE_CUDA 1 CACHE INTERNAL "")
    else()
      message(STATUS "CUDA *NOT* found.")
      set(HAVE_CUDA 0 CACHE INTERNAL "")
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

  elseif(module MATCHES "curl")

    find_package(CURL)
    if(CURL_FOUND)
      message(STATUS "CURL found.")
      list(APPEND link_3rd_party "${CURL_LIBRARIES}")
      list(APPEND include_3rd_party "${CURL_INCLUDE_DIRS}")
      set(HAVE_CURL 1 CACHE INTERNAL "")
    else()
      message(STATUS "CURL *NOT* found.")
      set(HAVE_CURL 0 CACHE INTERNAL "")
    endif()

  elseif(module MATCHES "magick")

    find_package(ImageMagick COMPONENTS Magick++)
    if(ImageMagick_FOUND)
      message(STATUS "ImageMagick found.")
      list(APPEND link_3rd_party "${ImageMagick_LIBRARIES}")
      list(APPEND include_3rd_party "${ImageMagick_INCLUDE_DIRS}")
      set(HAVE_ImageMagick 1 CACHE INTERNAL "")
    else()
      message(STATUS "ImageMagick *NOT* found.")
      set(HAVE_ImageMagick 0 CACHE INTERNAL "")
    endif()

  else()

    set(found_3rd_party FALSE)

  endif()

endmacro()

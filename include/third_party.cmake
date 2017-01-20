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

  # see if OPTIONAL was given
  foreach(arg ${ARGN})
    if (arg MATCHES "OPTIONAL")
      set(is_optional TRUE)
    else()
      set(is_optional FALSE)
    endif()
  endforeach()

  if(module MATCHES "^boost$")

    if(WIN32)
      # needed for VS
      # give the boost auto linker the right idea
      set(Boost_USE_STATIC_LIBS ON)
      if("${MSVC_RUNTIME}" STREQUAL "static")
        set(Boost_USE_STATIC_RUNTIME ON)
      else()
        set(Boost_USE_STATIC_RUNTIME OFF)
      endif()
    endif()

    find_package(Boost COMPONENTS date_time filesystem program_options serialization signals system thread timer REQUIRED)
    if(Boost_FOUND)
      list(APPEND include_3rd_party ${Boost_INCLUDE_DIR})
      list(APPEND link_3rd_party ${Boost_LIBRARIES})
      message(STATUS "Boost found.")
    else()
      message(STATUS "Boost *NOT* found.")
    endif()

  elseif(module MATCHES "boost-timer")

    find_package(Boost COMPONENTS timer REQUIRED)
    if(Boost_FOUND)
      list(APPEND include_3rd_party ${Boost_INCLUDE_DIR})
      list(APPEND link_3rd_party ${Boost_LIBRARIES})
      message(STATUS "Boost timer found.")
    else()
      message(STATUS "Boost timer *NOT* found.")
    endif()

  elseif(module MATCHES "boost-thread")

    find_package(Boost COMPONENTS thread REQUIRED)
    if(Boost_FOUND)
      list(APPEND include_3rd_party ${Boost_INCLUDE_DIR})
      list(APPEND link_3rd_party ${Boost_LIBRARIES})
      message(STATUS "Boost thread found.")
    else()
      message(STATUS "Boost thread *NOT* found.")
    endif()

  elseif(module MATCHES "boost-system")

    find_package(Boost COMPONENTS system REQUIRED)
    if(Boost_FOUND)
      list(APPEND include_3rd_party ${Boost_INCLUDE_DIR})
      list(APPEND link_3rd_party ${Boost_LIBRARIES})
      message(STATUS "Boost system found.")
    else()
      message(STATUS "Boost system *NOT* found.")
    endif()

  elseif(module MATCHES "boost-signals")

    find_package(Boost COMPONENTS signals REQUIRED)
    if(Boost_FOUND)
      list(APPEND include_3rd_party ${Boost_INCLUDE_DIR})
      list(APPEND link_3rd_party ${Boost_LIBRARIES})
      message(STATUS "Boost signals found.")
    else()
      message(STATUS "Boost signals *NOT* found.")
    endif()

  elseif(module MATCHES "boost-serialization")

    find_package(Boost COMPONENTS serialization REQUIRED)
    if(Boost_FOUND)
      list(APPEND include_3rd_party ${Boost_INCLUDE_DIR})
      list(APPEND link_3rd_party ${Boost_LIBRARIES})
      message(STATUS "Boost serialization found.")
    else()
      message(STATUS "Boost serialization *NOT* found.")
    endif()

  elseif(module MATCHES "boost-program_options")

    find_package(Boost COMPONENTS program_options REQUIRED)
    if(Boost_FOUND)
      list(APPEND include_3rd_party ${Boost_INCLUDE_DIR})
      list(APPEND link_3rd_party ${Boost_LIBRARIES})
      message(STATUS "Boost program_options found.")
    else()
      message(STATUS "Boost program_options *NOT* found.")
    endif()

  elseif(module MATCHES "boost-filesystem")

    find_package(Boost COMPONENTS filesystem REQUIRED)
    if(Boost_FOUND)
      list(APPEND include_3rd_party ${Boost_INCLUDE_DIR})
      list(APPEND link_3rd_party ${Boost_LIBRARIES})
      message(STATUS "Boost filesystem found.")
    else()
      message(STATUS "Boost filesystem *NOT* found.")
    endif()

  elseif(module MATCHES "boost-date_time")

    find_package(Boost COMPONENTS date_time REQUIRED)
    if(Boost_FOUND)
      list(APPEND include_3rd_party ${Boost_INCLUDE_DIR})
      list(APPEND link_3rd_party ${Boost_LIBRARIES})
      message(STATUS "Boost date_time found.")
    else()
      message(STATUS "Boost date_time *NOT* found.")
    endif()

  elseif(module MATCHES "boost-test")

    find_package(Boost COMPONENTS unit_test_framework REQUIRED)
    if(Boost_FOUND)
      list(APPEND include_3rd_party ${Boost_INCLUDE_DIR})
      list(APPEND link_3rd_party ${Boost_LIBRARIES})
      message(STATUS "boost-test found.")
    else()
      message(STATUS "boost-test *NOT* found.")
    endif()

  elseif(module MATCHES "boost-python")

    # determine the python version to use based on the currently visible python interpreter
    find_package(PythonInterp QUIET)
    if(PYTHONINTERP_FOUND)
      message(STATUS "python interpreter version ${PYTHON_VERSION_STRING} found (${PYTHON_EXECUTABLE}).")
    else()
      message(WARNING "no python interpreter found -- that might end up ugly.")
    endif()

    # find python libs that fit to the version determined above
    find_package(PythonLibs REQUIRED)
    if(PYTHONLIBS_FOUND)
      list(APPEND include_3rd_party "${PYTHON_INCLUDE_DIRS}")
      list(APPEND link_3rd_party ${PYTHON_LIBRARIES})
      message(STATUS "python version ${PYTHONLIBS_VERSION_STRING} found.")
    else()
      message(STATUS "python *NOT* found.")
    endif()

    if(${PYTHONLIBS_VERSION_STRING} VERSION_LESS "3")
      find_package(Boost COMPONENTS python REQUIRED)
    else()
      find_package(Boost COMPONENTS python3 REQUIRED)
    endif()
    if(Boost_FOUND)
      list(APPEND include_3rd_party ${Boost_INCLUDE_DIR})
      list(APPEND link_3rd_party ${Boost_LIBRARIES})
      message(STATUS "boost-python found.")
    else()
      message(STATUS "boost-python *NOT* found.")
    endif()

  elseif(module MATCHES "numpy")

    find_package(NumPy REQUIRED)
    if (NUMPY_FOUND)
      list(APPEND include_3rd_party "${PYTHON_NUMPY_INCLUDE_DIR}")
      message(STATUS "NumPy found: ${PYTHON_NUMPY_INCLUDE_DIR}")
      set(HAVE_NUMPY 1 CACHE INTERNAL "")

        # determine the python version to use based on the currently visible python interpreter
        find_package(PythonInterp QUIET)
        if(PYTHONINTERP_FOUND)
          message(STATUS "python interpreter version ${PYTHON_VERSION_STRING} found.")
        else()
          message(WARNING "no python interpreter found -- that might end up ugly.")
        endif()

        # find python libs that fit to the version determined above
        find_package(PythonLibs REQUIRED)
        if(PYTHONLIBS_FOUND)
          list(APPEND include_3rd_party "${PYTHON_INCLUDE_DIRS}")
          list(APPEND link_3rd_party ${PYTHON_LIBRARIES})
          message(STATUS "python version ${PYTHONLIBS_VERSION_STRING} found.")
        else()
          message(STATUS "python *NOT* found.")
        endif()

    else()
      message(STATUS "NumPy *NOT* found")
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

    find_package(OpenGLX REQUIRED)
    if(OPENGL_FOUND)
      list(APPEND link_3rd_party ${OPENGL_LIBRARY})
      message(STATUS "OpenGL found.")
    else()
      message(STATUS "OpenGL *NOT* found.")
    endif()

  elseif(module MATCHES "glew")

    find_package(GLEW REQUIRED)
    if (GLEW_FOUND)
      list(APPEND include_3rd_party ${GLEW_INCLUDE_DIR})
      list(APPEND link_3rd_party ${GLEW_LIBRARY})
      message(STATUS "GLEW found.")
    else()
      message(STATUS "GLEW *NOT* found.")
    endif()

  elseif(module MATCHES "glut")

    find_package(GLUT REQUIRED)
    if (GLUT_FOUND)
      list(APPEND include_3rd_party ${GLUT_INCLUDE_DIR})
      list(APPEND link_3rd_party ${GLUT_LIBRARIES})
      message(STATUS "GLUT found.")
    else()
      message(STATUS "GLUT *NOT* found.")
    endif()

  elseif(module MATCHES "^vigra$")

    message(STATUS "Loogking for vigra, build dir set to ${Vigra_BUILD_DIR}")

    find_package(Vigra)
    if (Vigra_FOUND)

      list(APPEND include_3rd_party ${Vigra_INCLUDE_DIR})
      list(APPEND link_3rd_party ${Vigra_LIBRARIES})
      message(STATUS "Vigra found: ${Vigra_INCLUDE_DIR}")
      set(HAVE_VIGRA 1 CACHE INTERNAL "")

    else()

      message(STATUS "No vigra installation found. Will download and build vigra locally, unless you set Vigra_BUILD_DIR to an existing build of vigra.")
      find_3rd_party("vigra-git")

    endif()

  elseif(module MATCHES "vigra-git")

    # check if vigra-git was already added as an external project
    if (NOT TARGET vigra-git)

      include(ExternalProject)

      message(STATUS "vigra git version requested -- will download and build it on demand.")

      # get additional build options
      string(REPLACE "@" ";" module_args ${module})
      message(STATUS ${module})
      message(STATUS ${module_args})
      list(LENGTH module_args size)
      if (size GREATER 1)
        list(GET module_args 1 args)
      else()
        set(args "")
      endif()
      message(STATUS "  additional vigra build arguments: ${args}")

      ExternalProject_Add(
        vigra-git
        GIT_REPOSITORY http://github.com/funkey/vigra.git
        GIT_TAG 46def039b0856a46fa2f1a70be38223777cd7f6c
        UPDATE_COMMAND ""
        PATCH_COMMAND ""
        CMAKE_ARGS -DAUTOBUILD_TESTS:BOOL=OFF -DWITH_VIGRANUMPY:BOOL=OFF -DCMAKE_CXX_COMPILER:STRING=${CMAKE_CXX_COMPILER} ${args}
        INSTALL_COMMAND ""
      )
      ExternalProject_Get_Property(vigra-git SOURCE_DIR)
      ExternalProject_Get_Property(vigra-git BINARY_DIR)
      set(Vigra_INCLUDE_DIR ${SOURCE_DIR}/include CACHE INTERNAL "")
      set(Vigra_LIBRARIES "${BINARY_DIR}/src/impex/libvigraimpex${CMAKE_SHARED_LIBRARY_SUFFIX}" CACHE INTERNAL "")
      set(HAVE_VIGRA 1 CACHE INTERNAL "")

    endif()

    list(APPEND include_3rd_party ${Vigra_INCLUDE_DIR})
    list(APPEND link_3rd_party ${Vigra_LIBRARIES})
    list(APPEND misc_targets vigra-git)

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

  elseif(module MATCHES "scip")

    # check if scip was already added as an external project
    if (NOT TARGET scip)

      include(ExternalProject)

      message(STATUS "scip optimization suite requested -- will download and build it on demand.")
      ExternalProject_Add(
        scip
        URL http://scip.zib.de/download/release/scipoptsuite-3.2.0.tgz
        UPDATE_COMMAND ""
        PATCH_COMMAND ""
        CONFIGURE_COMMAND ""
        BUILD_COMMAND make scipoptlib GMP=false ZLIB=false READLINE=false
        BUILD_IN_SOURCE 1
        INSTALL_COMMAND ""
      )
      ExternalProject_Get_Property(scip SOURCE_DIR)
      set(SCIP_INCLUDE_DIRS ${SOURCE_DIR}/scip-3.2.0/src/ ${SOURCE_DIR}/soplex-2.2.0 CACHE INTERNAL "")
      if (${CMAKE_SYSTEM_NAME} MATCHES "Darwin")
        set(SCIP_LIBRARIES "${SOURCE_DIR}/lib/libscipopt-3.2.0.darwin.x86_64.gnu.opt.a" CACHE INTERNAL "")
      else()
        set(SCIP_LIBRARIES "${SOURCE_DIR}/lib/libscipopt-3.2.0.linux.x86_64.gnu.opt.a" CACHE INTERNAL "")
      endif()
      set(HAVE_SCIP 1 CACHE INTERNAL "")

    endif()

    list(APPEND include_3rd_party ${SCIP_INCLUDE_DIRS})
    list(APPEND link_3rd_party ${SCIP_LIBRARIES})
    list(APPEND misc_targets scip)

  elseif(module MATCHES "lemon-hg")

    # check if lemon-hg was already added as an external project
    if (NOT TARGET lemon-hg)

      include(ExternalProject)

      message(STATUS "lemon hg version requested -- will download and build it on demand.")
      ExternalProject_Add(
        lemon-hg
        HG_REPOSITORY http://lemon.cs.elte.hu/hg/lemon
        HG_TAG 89e1877e335f
        UPDATE_COMMAND ""
        PATCH_COMMAND ""
        CMAKE_ARGS -DCMAKE_CXX_COMPILER:STRING=${CMAKE_CXX_COMPILER}
        INSTALL_COMMAND ""
      )
      ExternalProject_Get_Property(lemon-hg SOURCE_DIR)
      ExternalProject_Get_Property(lemon-hg BINARY_DIR)
      set(LEMON_INCLUDE_DIRS ${SOURCE_DIR} ${BINARY_DIR} CACHE INTERNAL "")
      set(LEMON_LIBRARIES "${BINARY_DIR}/lemon/libemon.a" CACHE INTERNAL "")
      set(HAVE_LEMON 1 CACHE INTERNAL "")

    endif()

    list(APPEND include_3rd_party ${LEMON_INCLUDE_DIRS})
    list(APPEND link_3rd_party ${LEMON_LIBRARIES})
    list(APPEND misc_targets lemon-hg)

  elseif(module MATCHES "eigen-hg")

    # check if eigen-hg was already added as an external project
    if (NOT TARGET eigen-hg)

      include(ExternalProject)

      message(STATUS "eigen hg version requested -- will download it on demand.")
      ExternalProject_Add(
        eigen-hg
        HG_REPOSITORY https://bitbucket.org/eigen/eigen/
        HG_TAG 3.2.2
        UPDATE_COMMAND ""
        PATCH_COMMAND ""
        CONFIGURE_COMMAND ""
        BUILD_COMMAND ""
        INSTALL_COMMAND ""
      )
      ExternalProject_Get_Property(eigen-hg SOURCE_DIR)
      ExternalProject_Get_Property(eigen-hg BINARY_DIR)
      set(EIGEN_INCLUDE_DIRS ${SOURCE_DIR} CACHE INTERNAL "")
      set(HAVE_EIGEN 1 CACHE INTERNAL "")

    endif()

    list(APPEND include_3rd_party ${EIGEN_INCLUDE_DIRS})
    list(APPEND misc_targets eigen-hg)

  elseif(module MATCHES "^fftw$")

    find_package(FFTW REQUIRED)
    if(FFTW_FOUND)
      list(APPEND include_3rd_party ${FFTW_INCLUDES})
      list(APPEND link_3rd_party ${FFTW_LIBRARIES})
      message(STATUS "FFTW found.")
      set(HAVE_FFTW 1 CACHE INTERNAL "")
    else()
      message(STATUS "FFTW *NOT* found.")
      set(HAVE_FFTW 0 CACHE INTERNAL "")
    endif()

  elseif(module MATCHES "fftwf")

    find_package(FFTWF REQUIRED)
    if(FFTWF_FOUND)
      list(APPEND include_3rd_party ${FFTWF_INCLUDES})
      list(APPEND link_3rd_party ${FFTWF_LIBRARIES})
      message(STATUS "FFTWF found.")
      set(HAVE_FFTWF 1 CACHE INTERNAL "")
    else()
      message(STATUS "FFTWF *NOT* found.")
      set(HAVE_FFTWF 0 CACHE INTERNAL "")
    endif()

  elseif(module MATCHES "cairo")

    find_package(Cairo REQUIRED)
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

    # check if skia was already added as an external project
    if (NOT TARGET skia)

      find_package(Skia)
      if (SKIA_FOUND)

        message(STATUS "Skia found: ${Skia_LIBRARY}")
        set(HAVE_SKIA 1 CACHE INTERNAL "")

        list(APPEND include_3rd_party ${Skia_INCLUDE_DIR}/config)
        list(APPEND include_3rd_party ${Skia_INCLUDE_DIR}/core)
        list(APPEND include_3rd_party ${Skia_INCLUDE_DIR}/effects)
        list(APPEND include_3rd_party ${Skia_INCLUDE_DIR}/pdf)
        if (WIN32)
          list(APPEND link_3rd_party ${Skia_LIBRARY})
        else()
          list(APPEND link_3rd_party ${Skia_LIBRARY} pthread)
        endif()

      else()
        message(STATUS "Skia not found")
        message(STATUS "set Skia_BUILD_DIR to where you compiled skia")
      endif()

    endif()


  elseif(module MATCHES "freetype")

    find_package(Freetype REQUIRED)
    if (FREETYPE_FOUND)
      list(APPEND include_3rd_party ${FREETYPE_INCLUDE_DIRS})
      list(APPEND link_3rd_party ${FREETYPE_LIBRARIES})
      list(APPEND link_3rd_party "-lfontconfig")
      message(STATUS "Freetype found.")
    else()
      message(STATUS "Freetype *NOT* found.")
    endif()

  elseif(module MATCHES "ftgl")

    find_package(FTGL REQUIRED)
    if (FTGL_FOUND)
      list(APPEND include_3rd_party ${FTGL_INCLUDE_DIR})
      list(APPEND link_3rd_party ${FTGL_LIBRARY})
      message(STATUS "FTGL found.")
    else()
      message(STATUS "FTGL *NOT* found.")
    endif()

  elseif(module MATCHES "tiff")

    find_package(TIFF REQUIRED)
    if(TIFF_FOUND)
      message(STATUS "TIFF found.")
      list(APPEND link_3rd_party ${TIFF_LIBRARY})
      list(APPEND link_3rd_party "-llzma")
      set(HAVE_TIFF 1 CACHE INTERNAL "")
    else()
      message(STATUS "TIFF *NOT* found.")
      set(HAVE_TIFF 0 CACHE INTERNAL "")
    endif()

  elseif(module MATCHES "png")

    find_package(PNG REQUIRED)
    if(PNG_FOUND)
      message(STATUS "PNG found.")
      list(APPEND link_3rd_party ${PNG_LIBRARY})
      set(HAVE_PNG 1 CACHE INTERNAL "")
    else()
      message(STATUS "PNG *NOT* found.")
      set(HAVE_PNG 0 CACHE INTERNAL "")
    endif()

  elseif(module MATCHES "cuda")

    find_package(CUDA REQUIRED)
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
      configure_file(${PROJECT_SOURCE_DIR}/cmake/doxygen.in ${CMAKE_BINARY_DIR}/doxygen.conf)
      add_custom_target(
          primdoc
          ${DOXYGEN_EXECUTABLE} ${CMAKE_BINARY_DIR}/doxygen.conf
          WORKING_DIRECTORY ${CMAKE_BINARY_DIR}
          COMMENT "Generating Doxygen documentation"
          VERBATIM)
      message(STATUS "Doxygen found.")
    else()
      message(STATUS "Doxygen *NOT* found.")
    endif()

  elseif(module MATCHES "curl")

    find_package(CURL REQUIRED)
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

    find_package(ImageMagick COMPONENTS Magick++ REQUIRED)
    if(ImageMagick_FOUND)
      message(STATUS "ImageMagick found.")
      list(APPEND link_3rd_party "${ImageMagick_LIBRARIES}")
      list(APPEND include_3rd_party "${ImageMagick_INCLUDE_DIRS}")
      set(HAVE_ImageMagick 1 CACHE INTERNAL "")
    else()
      message(STATUS "ImageMagick *NOT* found.")
      set(HAVE_ImageMagick 0 CACHE INTERNAL "")
    endif()

  elseif(module MATCHES "mysql")

    find_package(MySQL REQUIRED)
    if(MYSQL_FOUND)
      message(STATUS "MySQL found.")
      list(APPEND link_3rd_party "${MYSQL_LIBRARIES}")
      list(APPEND include_3rd_party "${MYSQL_INCLUDE_DIR}")
      set(HAVE_MYSQL 1 CACHE INTERNAL "")
    else()
      message(STATUS "MySQL *NOT* found.")
      set(HAVE_MYSQL 0 CACHE INTERNAL "")
    endif()

  else()

    set(found_3rd_party FALSE)

  endif()

endmacro()

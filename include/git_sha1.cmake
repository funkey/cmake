# CMake script to include the git sha1 hash into a project.
# Depends on define_module.cmake.
#
# After including this file in any of your CMakeLists.txt, e.g.,
#
#       include(${CMAKE_SOURCE_DIR}/cmake/include/define_module.cmake)
#       include(${CMAKE_SOURCE_DIR}/cmake/include/git_sha1.cmake)
#
# a new module¹ named "git_sha1" will be created. Other modules can link to it
# and access the git sha1 in their sources in the following way:
#
#       #include <iostream>
#       #include <git_sha1.h> // needed for declaration of __git_sha1
#
#       void reportGitRevision() {
#
#         std::cout << __git_sha1 << std::endl;
#       }
#
# You can test whether this script was included by querying HAVE_GIT_SHA1, i.e.,
#
#      #include <config.h>
#      #ifdef HAVE_GIT_SHA1
#      #include <git_sha1.h>
#      #endif
#
# [1] Modules are described in detail in define_module.cmake.

# get the module to query the git revision
include(${CMAKE_CURRENT_LIST_DIR}/git_sha1/GetGitRevisionDescription.cmake)

# get the git revision
get_git_head_revision(GIT_REFSPEC GIT_SHA1)
set(HAVE_GIT_SHA1 1 CACHE INTERNAL "")

# create a new target "git_sha1"
add_subdirectory(${CMAKE_CURRENT_LIST_DIR}/git_sha1)
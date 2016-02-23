message("Processing git_sha1 module")

configure_file("${CMAKE_CURRENT_SOURCE_DIR}/git_sha1.cpp.in" "${CMAKE_CURRENT_BINARY_DIR}/git_sha1.cpp" @ONLY)
define_module(git_sha1 OBJECT SOURCES "${CMAKE_CURRENT_BINARY_DIR}/git_sha1.cpp")
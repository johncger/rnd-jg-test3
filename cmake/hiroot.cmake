if (NOT DEFINED HIROOT)
  get_filename_component(HIROOT ${CMAKE_CURRENT_SOURCE_DIR}/.. ABSOLUTE)
  message(STATUS "HIROOT not defined, setting it to ${HIROOT}") 
  message(STATUS "HIROOT may be set by adding the command line argument -DHIROOT=/my/root/dir.")
endif()

message(STATUS "Harvest Root: ${HIROOT}")
message(STATUS "CMake prefix path: ${CMAKE_PREFIX_PATH}")
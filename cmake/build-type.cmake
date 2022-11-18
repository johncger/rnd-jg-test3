# if no build type default to release
if(NOT CMAKE_BUILD_TYPE)
  set(CMAKE_BUILD_TYPE Release)
endif()

string(TOUPPER "${CMAKE_BUILD_TYPE}" UPPER_BUILD_TYPE)
if (UPPER_BUILD_TYPE MATCHES DEBUG)
   add_definitions(-DDEBUG_BUILD=true)
   message(STATUS "Debug build")
else()
   add_definitions(-DNDEBUG)
   message(STATUS "Release build")
endif()


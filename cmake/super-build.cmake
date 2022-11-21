include (ExternalProject)

set_property (DIRECTORY PROPERTY EP_BASE Dependencies)

option(DOWNLOAD_DEPENDENCIES "Should dependencies be downloaded" OFF)
foreach (SUPER_PROJ IN LISTS SUPER_BUILD_PROJECTS)
   ExternalProject_Add(${SUPER_PROJ}
     SOURCE_DIR ${HIROOT}/${SUPER_PROJ}
     BINARY_DIR ${HIROOT}/${SUPER_PROJ}/build
     GIT_REPOSITORY https://github.com/johncger/rnd-jg-test2.git
     GIT_TAG origin/develop
   )
endforeach()

# Invoke the original project cmake
ExternalProject_Add (${PROJECT_NAME}_redux
  DEPENDS ${SUPER_BUILD_PROJECTS}
  SOURCE_DIR ${PROJECT_SOURCE_DIR}
  BINARY_DIR ${PROJECT_SOURCE_DIR}/build
  CMAKE_ARGS
  INSTALL_COMMAND ""
  )
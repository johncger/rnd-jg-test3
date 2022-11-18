set(CMAKE_CXX_STANDARD 14)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_CXX_EXTENSIONS OFF)
set(CMAKE_EXPORT_COMPILE_COMMANDS ON)

set_property(GLOBAL PROPERTY USE_FOLDERS ON)

set(CMAKE_CXX_FLAGS_DEBUG_INIT "-Wall -g")
set(CMAKE_CXX_FLAGS_RELEASE_INIT
    "-Wall -O3 -DNDEBUG -ffast-math -fexpensive-optimizations -flto -fno-exceptions"
)
# Create interface target so that compile flags can be exported
add_library(ProjectConfiguration INTERFACE)
target_compile_options(ProjectConfiguration
    INTERFACE
        -Wall
        -Werror
        $<$<COMPILE_LANGUAGE:CXX>:-Weffc++>  # generator expression
)
target_compile_features(ProjectConfiguration
    INTERFACE
        cxx_std_14
)
# Project Name

Short description

## About

Detailed description

# Getting Started

If you are new here, please read the [contribution](./.github/contributing.md) documentation.

To enable C++ CMake CI, ensure `build_cmake.yml` and `cmake_config.json` files are present. Information about pipeline setup can be found in [templ-cmake](https://github.com/HInfinity/templ-cmake/blob/main/.github/ci.md).

## Requirements

- Project requirements for development and release

## Project Layout

```
├── .github
├── .vscode
├── assets
├── build
├── cmake
│   ├── Linter.cmake
│   └── ProjectCPack.cmake
├── install
│   └── install.sh
├── licenses
│   └── external.txt
├── packages
│   └── project.deb
├── project
│   ├── configs
│   │   └── example.json
│   ├── include
│   │   ├── external
│   │   |    └── ExternalExample.hpp
│   │   ├── interface
│   │   |    └── InterfaceExample.hpp
│   │   └── internal
│   │        └── InternalExample.hpp
│   ├── lib
│   │   ├── arm64
│   │   |    └── example.so.1.0.0
│   │   └── x86_64
│   │        ├── example.so
│   │        └── example.so.1.0.0
│   ├── log
│   │   └── example.txt
│   └── src
│   │   └── Example.cpp
├── scripts
│   ├── arm64
│   │   └── example.sh
│   └── x86_64
│       └── example.sh
├── test
│   └── test.cpp
├── .clang-format
├── .clang-tidy
├── .gitignore
├── CPPLINT.cfg
├── README.md
└── workspace.code-workspace

```

## Installation

1. Install development dependencies:

```sh
 dependencies to install
```

# Usage

1. Open `workspace.code-workspace` in vscode.

2. Use either the terminal or vscode UI instructions to run the application.

## Terminal

1. Open a new terminal, create a `build` directory and navigate to the directory

2. Configure the build type and any other flags and build the project.

```sh
cmake .. -DCMAKE_BUILD_TYPE=Debug 
ninja
```

3. Navigate to `build/bin/Linux/arm64` or `build/bin/Linux/armv7l` or `build/bin/Linux/x86_64` and run the software:

```sh
cd ./build/bin/Linux/x86_64
./Nodestream
```

### Debugging

1. GDB - primary debugger for C++ projects:

```sh
cd ./build/bin/x86_64
gdb ./Nodestream
```

- run - to start the application
- quit - to quit GDB
- bt - backtrace
- thread apply all bt - show backtrace from all threads

2. valgrind - memory management software

3. Navigate to `Project/Nodestream/main.cpp` and choose the logging level required

## vscode UI

1. Update `.vscode/settings.json` if you need to add build flags.

2. Locate `Play` button at the bottom of the code editor and run the software.

### Debugging

Vscode allows to easily debug applications by launching the debugger through the editor. The debug button is located at the bottom of the editor with a _bug_ icon.

## Deployment

1. Update software version

- Open `cmake/project-cpack.cmake` and update CPACK_PACKAGE_VERSION.

2. Build .DEB package

```sh
cmake .. -DCMAKE_BUILD_TYPE=Release
make -j8
cpack
```

3. Navigate to `install/` and update the script if required

4. Navigate to `packages/` and locate the newly build debian package

5. Ensure ProjectName.deb packages are present

6. ...

## FAQ

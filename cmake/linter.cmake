#
# Copyright (c) 2022 Harvest Technology Group Pty Ltd. All Rights Reserved.
#

# Allows to perform linting and formatting, uses ${LINT_SOURCES},
# include/internal, include/interface, compile_commands.json,
# ${CMAKE_SOURCE_DIR}, ${CMAKE_BINARY_DIR}
message("")
message("---------CMake Commands---------")
message(
  STATUS
    "'-DEXCLUDE_DIRECTORIES=' to exclude directories within the list using a comma(,) separator."
)
message(
  STATUS
    "'-DEXCLUDE_FILES=' to exclude specific files within the list using a comma(,) separator."
)
message(
  STATUS
    "'-DNOLINT=1' to disable linting and formatting checks, the 2 options above become unused"
)
message("")

if(NOT NOLINT)
  message("---------Make Commands---------")
  message(
    STATUS
      "'make' to build, run cpplint, cppcheck and clang-tidy(does not apply fixes automatically)"
  )
  message(STATUS "'make cppcheck' to only run cppcheck and build")
  message(STATUS "'make cpplint' to only run cpplint and build")
  message(
    STATUS "'make format' to run clang-format, apply styling fixes and build")
  message(STATUS "'make tidy' to run clang-tidy, apply linting fixes and build")
  message("")
  message("---------CMake Example---------")
  message(
    STATUS
      "cmake .. -DEXCLUDE_DIRECTORIES=./include/external,./build -DEXCLUDE_FILES=./src/ClassToExclude.cpp"
  )
  message("")

  # message("Binary Directory: '${CMAKE_BINARY_DIR}'") message("Source
  # Directory: '${CMAKE_SOURCE_DIR}'") Define default exclude directories
  if(NOT EXCLUDE_DIRECTORIES)
    if(WIN32)
      set(EXCLUDE_DIRECTORIES project/include/external,build)
    else()
      set(EXCLUDE_DIRECTORIES ./project/include/external,./build)
    endif()
  endif()

  # message(WARNING "${EXCLUDED_DIRECTORIES}") message(WARNING
  # "${EXCLUDE_DIRECTORIES}")

  # Define default exclude headers

  if(WIN32)
    # Excluding files is not implemented for Win32
    set(FILES_LIST
        ${EXCLUDE_DIRECTORIES}
        "| Get-ChildItem -Recurse | where name -match '.*\\.cpp$|.*\\.c$|.*\\.h$|.*\\.hpp$' | select fullname | foreach { $_.fullname } | Resolve-Path -Relative"
    )

    # message(WARNING "FILES_LIST: ${FILES_LIST}")

    string(REPLACE ";" " " FILES_LIST "${FILES_LIST}")
    file(WRITE ${CMAKE_BINARY_DIR}/filesToCheck.ps1
         "Get-ChildItem  -Exclude ${FILES_LIST} ")
    execute_process(
      COMMAND powershell ${CMAKE_BINARY_DIR}/filesToCheck.ps1
      OUTPUT_VARIABLE FILES_TO_CHECK
      WORKING_DIRECTORY ${CMAKE_SOURCE_DIR})

    message(STATUS "Files to lint: ${FILES_TO_CHECK}")
  else()
    string(REPLACE "," ";" EXCLUDE_DIRECTORIES "${EXCLUDE_DIRECTORIES}")

    set(EXCLUDED_DIRECTORIES "")
    foreach(my_entry IN LISTS EXCLUDE_DIRECTORIES)
      set(EXCLUDED_DIRECTORIES ${EXCLUDED_DIRECTORIES} -path ${my_entry} -prune
                               -false -o)
    endforeach()

    if(NOT EXCLUDE_FILES)

    else()
      string(REPLACE "," ";" EXCLUDE_FILES "${EXCLUDE_FILES}")

      set(EXCLUDED_FILES "")
      foreach(my_entry IN LISTS EXCLUDE_FILES)
        set(EXCLUDED_FILES ${EXCLUDED_FILES} | grep -v ${my_entry})
      endforeach()

    endif()

    set(FILES_LIST
        ${EXCLUDED_DIRECTORIES}
        " -iname '*.hpp' -o -iname '*.h' -o -iname '*.cpp' -o -iname '*.c' "
        ${EXCLUDED_FILES})

    # message(WARNING "FILES_LIST: ${FILES_LIST}")

    string(REPLACE ";" " " FILES_LIST "${FILES_LIST}")
    file(WRITE ${CMAKE_BINARY_DIR}/filesToCheck.sh "find  ./ ${FILES_LIST}")
    execute_process(
      COMMAND bash ${CMAKE_BINARY_DIR}/filesToCheck.sh
      OUTPUT_VARIABLE FILES_TO_CHECK
      WORKING_DIRECTORY ${CMAKE_SOURCE_DIR})
    # file(REMOVE ${CMAKE_SOURCE_DIR}/build/filesToCheck.sh)
    message(STATUS "Files to lint: ${FILES_TO_CHECK}")
  endif()

  # Add clang-tidy
  find_program(CLANG_TIDY clang-tidy)
  if(NOT CLANG_TIDY)
    message(WARNING "Could not find clang-tidy.")
  else()
    # Firstly fix source files by using the first command and then fix header
    # files by using the second command to prevent applying changes more than
    # once.
    if(WIN32)
      add_custom_target(
        tidy
        COMMAND
          powershell
          "&'${CLANG_TIDY}' -p '${CMAKE_BINARY_DIR}' -fix-errors @(&'${CMAKE_BINARY_DIR}/filesToCheck.ps1')"
        COMMAND
          powershell
          "&'${CLANG_TIDY}' -p '${CMAKE_BINARY_DIR}' -fix-errors @(&'${CMAKE_BINARY_DIR}/filesToCheck.ps1')"
        WORKING_DIRECTORY ${CMAKE_SOURCE_DIR})
    else()
      add_custom_target(
        tidy
        COMMAND bash ${CMAKE_BINARY_DIR}/filesToCheck.sh | xargs ${CLANG_TIDY}
                -p ${CMAKE_BINARY_DIR} -fix-errors
        COMMAND bash ${CMAKE_BINARY_DIR}/filesToCheck.sh | xargs ${CLANG_TIDY}
                -p ${CMAKE_BINARY_DIR} -fix-errors
        WORKING_DIRECTORY ${CMAKE_SOURCE_DIR})
    endif()
    # set(CMAKE_CXX_CLANG_TIDY ${CLANG_TIDY} )
  endif()

  # TODO: get it to work on windows Add clang-format
  find_program(CLANG_FORMAT clang-format)
  if(NOT CLANG_FORMAT)
    message(WARNING "Could not find clang-format, target format is disabled.")
  else()
    if(WIN32)
      add_custom_target(
        format
        COMMAND
          powershell
          "&'${CLANG_FORMAT}' -style=file -assume-filename=.clang-format -i -verbose @(&'${CMAKE_BINARY_DIR}/filesToCheck.ps1')"
        WORKING_DIRECTORY ${CMAKE_SOURCE_DIR})
    else()
      add_custom_target(
        format
        COMMAND bash ${CMAKE_BINARY_DIR}/filesToCheck.sh | xargs ${CLANG_FORMAT}
                -style=file -assume-filename=.clang-format -i -verbose
        WORKING_DIRECTORY ${CMAKE_SOURCE_DIR})
    endif()
  endif()
  # TODO: get it to work on windows Add Analyze with CppCheck target if CppCheck
  # is installed -
  if(WIN32)
    find_program(
      CPPCHECK cppcheck
      NAMES cppcheck
      HINTS $ENV{PROGRAMFILES}/cppcheck)
    if(NOT CPPCHECK)
      message(WARNING "Could not find cppcheck.")
    else()
      set(EXCLUDED_DIRS "")
      #[[foreach (my_entry IN LISTS EXCLUDE_DIRECTORIES)
                execute_process (
                    COMMAND bash -c "realpath ${my_entry} --zero"
                    OUTPUT_VARIABLE temp
                    WORKING_DIRECTORY ${CMAKE_SOURCE_DIR}
                )
                set(EXCLUDED_DIRS ${EXCLUDED_DIRS}  --suppress=*:${temp}/*)
            endforeach()

            foreach (my_entry IN LISTS EXCLUDE_FILES)
                execute_process (
                    COMMAND bash -c "realpath ${my_entry} --zero"
                    OUTPUT_VARIABLE temp
                    WORKING_DIRECTORY ${CMAKE_SOURCE_DIR}
                )
                set(EXCLUDED_DIRS ${EXCLUDED_DIRS}  --suppress=*:${temp})
            endforeach()]]

      set(CPPCHECK_COMMAND
          --std=c++14 --language=c++ --enable=all
          --suppress=missingIncludeSystem
          --project=${CMAKE_BINARY_DIR}/compile_commands.json ${EXCLUDED_DIRS})
      add_custom_target(
        cppcheck
        COMMAND ${CPPCHECK} ${CPPCHECK_COMMAND}
        WORKING_DIRECTORY ${CMAKE_SOURCE_DIR})
      # set(CMAKE_CXX_CPPCHECK ${CPPCHECK} ${CPPCHECK_COMMAND})
    endif()
  elseif(LINUX)
    # Add cppcheck
    find_program(CPPCHECK cppcheck)
    if(NOT CPPCHECK)
      message(WARNING "Could not find cppcheck.")
    else()
      set(EXCLUDED_DIRS "")
      foreach(my_entry IN LISTS EXCLUDE_DIRECTORIES)
        execute_process(
          COMMAND bash -c "realpath ${my_entry} --zero"
          OUTPUT_VARIABLE temp
          WORKING_DIRECTORY ${CMAKE_SOURCE_DIR})
        set(EXCLUDED_DIRS ${EXCLUDED_DIRS} --suppress=*:${temp}/*)
      endforeach()

      foreach(my_entry IN LISTS EXCLUDE_FILES)
        execute_process(
          COMMAND bash -c "realpath ${my_entry} --zero"
          OUTPUT_VARIABLE temp
          WORKING_DIRECTORY ${CMAKE_SOURCE_DIR})
        set(EXCLUDED_DIRS ${EXCLUDED_DIRS} --suppress=*:${temp})
      endforeach()

      set(CPPCHECK_COMMAND
          --std=c++14 --language=c++ --enable=all
          --suppress=missingIncludeSystem
          --project=${CMAKE_BINARY_DIR}/compile_commands.json ${EXCLUDED_DIRS})
      add_custom_target(
        cppcheck
        COMMAND ${CPPCHECK} ${CPPCHECK_COMMAND}
        WORKING_DIRECTORY ${CMAKE_SOURCE_DIR})
      set(CMAKE_CXX_CPPCHECK ${CPPCHECK} ${CPPCHECK_COMMAND})
    endif()
  endif()

  # TODO: get it to work on windows.

  # Add cpplint
  if(WIN32)

  else()
    find_program(CPPLINT cpplint)
    if(NOT CPPLINT)
      message(WARNING "Could not find cpplint.")
    else()
      set(EXCLUDED_DIRS "")
      foreach(my_entry IN LISTS EXCLUDE_DIRECTORIES)
        execute_process(
          COMMAND bash -c "realpath ${my_entry} --zero"
          OUTPUT_VARIABLE TEMP
          WORKING_DIRECTORY ${CMAKE_SOURCE_DIR})
        set(EXCLUDED_DIRS ${EXCLUDED_DIRS} --exclude=${TEMP})
      endforeach()

      foreach(my_entry IN LISTS EXCLUDE_FILES)
        execute_process(
          COMMAND bash -c "realpath ${my_entry} --zero"
          OUTPUT_VARIABLE TEMP
          WORKING_DIRECTORY ${CMAKE_SOURCE_DIR})
        set(EXCLUDED_DIRS ${EXCLUDED_DIRS} --exclude=${TEMP})
      endforeach()

      add_custom_target(
        cpplint
        COMMAND bash ${CMAKE_BINARY_DIR}/filesToCheck.sh | xargs ${CPPLINT}
                ${EXCLUDED_DIRS}
        WORKING_DIRECTORY ${CMAKE_SOURCE_DIR})
      # set(CMAKE_CXX_CPPLINT ${CPPLINT} ${EXCLUDED_DIRS} ${FILES_TO_CHECK})
    endif()
  endif()

  #[[if(WIN32)
     file(REMOVE ${CMAKE_BINARY_DIR}/filesToCheck.ps1)
  else()
     file(REMOVE ${CMAKE_BINARY_DIR}/filesToCheck.sh)
  endif()]]
endif()

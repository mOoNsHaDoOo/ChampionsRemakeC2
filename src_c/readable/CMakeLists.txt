# Champions of Krynn - port asm -> C, build host con CMake e SDL2.
#
# Linux / macOS:
#   cmake -S . -B build-cmake -DCMAKE_BUILD_TYPE=Release
#   cmake --build build-cmake
#
# Visual Studio 2022 (x86 o x64), con SDL2 scaricata da NuGet:
#   windows\get-sdl2-nuget.cmd
#   cmake --preset vs2022-x64      oppure   cmake --preset vs2022-x86
#   cmake --build --preset vs2022-x64-release
#
# Il build Amiga (SAS/C) usa lo smakefile, non questo file.
cmake_minimum_required(VERSION 3.16)
project(ChampionsOfKrynn LANGUAGES C)

option(COK_BUILD_TESTS "Compila i test delle singole routine" ON)

# SDL2, in quest'ordine:
#  1. Windows: la cartella preparata da windows/get-sdl2-nuget.ps1
#     (pacchetti NuGet sdl2.nuget / sdl2.nuget.redist), x86 o x64;
#  2. il pacchetto CMake (vcpkg, SDL2-devel-VC, Homebrew, distribuzioni);
#  3. pkg-config.
set(COK_SDL2_NUGET_DIR "${CMAKE_CURRENT_SOURCE_DIR}/third_party/sdl2-nuget"
    CACHE PATH "SDL2 scaricata da NuGet (windows/get-sdl2-nuget.ps1)")
if(WIN32 AND EXISTS "${COK_SDL2_NUGET_DIR}/include/SDL.h")
    if(CMAKE_SIZEOF_VOID_P EQUAL 8)
        set(COK_SDL2_ARCH x64)
    else()
        set(COK_SDL2_ARCH Win32)
    endif()
    add_library(cok_sdl2 SHARED IMPORTED)
    set_target_properties(cok_sdl2 PROPERTIES
        IMPORTED_IMPLIB "${COK_SDL2_NUGET_DIR}/lib/${COK_SDL2_ARCH}/SDL2.lib"
        IMPORTED_LOCATION "${COK_SDL2_NUGET_DIR}/bin/${COK_SDL2_ARCH}/SDL2.dll"
        INTERFACE_INCLUDE_DIRECTORIES "${COK_SDL2_NUGET_DIR}/include")
    set(COK_SDL2_TARGET cok_sdl2)
    message(STATUS "SDL2 da NuGet: ${COK_SDL2_NUGET_DIR} (${COK_SDL2_ARCH})")
endif()
if(NOT COK_SDL2_TARGET)
    find_package(SDL2 CONFIG QUIET)
endif()
if(COK_SDL2_TARGET)
elseif(TARGET SDL2::SDL2)
    set(COK_SDL2_TARGET SDL2::SDL2)
elseif(TARGET SDL2::SDL2-static)
    set(COK_SDL2_TARGET SDL2::SDL2-static)
else()
    find_package(PkgConfig QUIET)
    if(PkgConfig_FOUND)
        pkg_check_modules(SDL2 IMPORTED_TARGET sdl2)
    endif()
    if(TARGET PkgConfig::SDL2)
        set(COK_SDL2_TARGET PkgConfig::SDL2)
    else()
        message(FATAL_ERROR
            "SDL2 non trovata. Su Windows: windows\\get-sdl2-nuget.cmd. "
            "Altrimenti installare SDL2 (libsdl2-dev, brew install sdl2, "
            "vcpkg install sdl2) o indicare -DSDL2_DIR=<dir>/cmake del "
            "pacchetto SDL2-devel.")
    endif()
endif()

file(GLOB COK_GAME_SOURCES CONFIGURE_DEPENDS
     ${CMAKE_CURRENT_SOURCE_DIR}/*.c)
file(GLOB COK_HOST_SOURCES CONFIGURE_DEPENDS
     ${CMAKE_CURRENT_SOURCE_DIR}/host/*.c)
file(GLOB COK_HEADERS CONFIGURE_DEPENDS
     ${CMAKE_CURRENT_SOURCE_DIR}/*.h
     ${CMAKE_CURRENT_SOURCE_DIR}/host/*.h)

add_executable(cok ${COK_GAME_SOURCES} ${COK_HOST_SOURCES} ${COK_HEADERS})
target_include_directories(cok PRIVATE ${CMAKE_CURRENT_SOURCE_DIR})
target_link_libraries(cok PRIVATE ${COK_SDL2_TARGET})
set_target_properties(cok PROPERTIES C_STANDARD 99 C_STANDARD_REQUIRED ON
                      C_EXTENSIONS OFF)

if(MSVC)
    target_compile_definitions(cok PRIVATE _CRT_SECURE_NO_WARNINGS)
    target_compile_options(cok PRIVATE /W3 /utf-8)
    set_property(DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}
                 PROPERTY VS_STARTUP_PROJECT cok)
else()
    target_compile_options(cok PRIVATE -Wall -Wextra -pedantic)
endif()

# Windows: copia SDL2.dll accanto all'eseguibile.
if(WIN32)
    get_target_property(COK_SDL2_TYPE ${COK_SDL2_TARGET} TYPE)
    if(COK_SDL2_TYPE STREQUAL "SHARED_LIBRARY")
        add_custom_command(TARGET cok POST_BUILD
            COMMAND ${CMAKE_COMMAND} -E copy_if_different
                    $<TARGET_FILE:${COK_SDL2_TARGET}> $<TARGET_FILE_DIR:cok>)
    endif()
endif()

if(COK_BUILD_TESTS)
    enable_testing()
    add_executable(h015_test tests/h015_test.c h015_runtime.c)
    target_include_directories(h015_test PRIVATE ${CMAKE_CURRENT_SOURCE_DIR})
    if(MSVC)
        target_compile_definitions(h015_test PRIVATE _CRT_SECURE_NO_WARNINGS)
    endif()
    add_test(NAME h015_runtime COMMAND h015_test)

    # Read_ILBM (H040..H099) su un file .lbm: ilbm_test file.lbm out.bin,
    # poi scripts/check_ilbm.py file.lbm out.bin (decoder indipendente).
    add_executable(ilbm_test tests/ilbm_test.c h040.c h086.c h087.c h088.c
                   h054.c h099.c h039.c h098.c h002_dos.c h003_exec.c
                   h015_runtime.c h037.c ${COK_HOST_SOURCES})
    target_include_directories(ilbm_test PRIVATE ${CMAKE_CURRENT_SOURCE_DIR})
    target_link_libraries(ilbm_test PRIVATE ${COK_SDL2_TARGET})
    if(MSVC)
        target_compile_definitions(ilbm_test PRIVATE _CRT_SECURE_NO_WARNINGS)
    endif()
    # DAX_LoadBlock (H028): dax_test nome .ext id out.bin, poi
    # scripts/check_dax.py file id out.bin (lettore indipendente).
    add_executable(dax_test tests/dax_test.c h028_files.c h026_string.c h041.c
                   h031.c h021_intuition.c h002_dos.c h003_exec.c globals.c
                   ${COK_HOST_SOURCES})
    target_include_directories(dax_test PRIVATE ${CMAKE_CURRENT_SOURCE_DIR})
    target_link_libraries(dax_test PRIVATE ${COK_SDL2_TARGET})
    if(MSVC)
        target_compile_definitions(dax_test PRIVATE _CRT_SECURE_NO_WARNINGS)
    endif()

    # Con -DCOK_TEST_DATA=<cartella dei file del gioco> anche ctest lo usa.
    set(COK_TEST_DATA "" CACHE PATH "Cartella dei file del gioco per i test")
    find_package(Python3 COMPONENTS Interpreter QUIET)
    if(COK_TEST_DATA AND Python3_FOUND)
        foreach(lbm gothic.lbm scrn1b.lbm scrn2.lbm text1.lbm text2.lbm
                    charS.LBM charT.LBM)
            add_test(NAME ilbm_${lbm}
                     COMMAND ${CMAKE_COMMAND}
                             -DTEST=$<TARGET_FILE:ilbm_test>
                             -DPYTHON=${Python3_EXECUTABLE}
                             -DCHECK=${CMAKE_CURRENT_SOURCE_DIR}/../../scripts/check_ilbm.py
                             -DFILE=${COK_TEST_DATA}/${lbm}
                             -DOUT=${CMAKE_CURRENT_BINARY_DIR}/ilbm_${lbm}.bin
                             -P ${CMAKE_CURRENT_SOURCE_DIR}/tests/run_ilbm_test.cmake)
        endforeach()
    endif()
endif()

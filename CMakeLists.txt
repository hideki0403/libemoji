cmake_minimum_required(VERSION 3.5.1)
project(emoji)


# Common
#~~~~~~~~~
set(CMAKE_C_STANDARD 11)
set(CMAKE_C_STANDARD_REQUIRED ON)
set(CMAKE_C_EXTENSIONS OFF)
set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_CXX_EXTENSIONS OFF)

if(MSVC)
  set(CMAKE_C_FLAGS_DEBUG "/MTd")
  set(CMAKE_C_FLAGS_RELEASE "/MT")
  set(CMAKE_CXX_FLAGS_DEBUG "/MTd")
  set(CMAKE_CXX_FLAGS_RELEASE "/MT")
else()
  set(CMAKE_C_FLAGS_DEBUG "-MTd")
  set(CMAKE_C_FLAGS_RELEASE "-MT")
  set(CMAKE_CXX_FLAGS_DEBUG "-MTd")
  set(CMAKE_CXX_FLAGS_RELEASE "-MT")
  # set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -Wall -Wextra")
  # set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -Wall -Wextra")
  # set(CMAKE_CXX_FLAGS_DEBUG "-g3 -O0 -pg")
  # set(CMAKE_CXX_FLAGS_RELEASE "-O2 -s -DNDEBUG -march=native")
endif()

set(CMAKE_SUPPRESS_REGENERATION true)

set(LIBRARY_OUTPUT_DIRECTORY "lib")
set(EXECUTABLE_OUTPUT_PATH "bin")
set(CMAKE_ARCHIVE_OUTPUT_DIRECTORY  "tmp")
include_directories(
  ${CMAKE_SOURCE_DIR}/include
  ${CMAKE_SOURCE_DIR}/src
  ${CMAKE_SOURCE_DIR}/externals/skia
  ${CMAKE_SOURCE_DIR}/externals/skia/include/core
  ${CMAKE_SOURCE_DIR}/externals/skia/include/config
  ${CMAKE_SOURCE_DIR}/externals/skia/include/utils
  ${CMAKE_SOURCE_DIR}/externals/skia/include/gpu
  ${CMAKE_SOURCE_DIR}/externals/skia/include/encode
)
link_directories(
  ${CMAKE_SOURCE_DIR}/tmp
)


# emoji
#~~~~~~~~
file(GLOB emoji_files "src/*.cpp")
add_library(emoji STATIC
  ${emoji_files}
)
add_dependencies(emoji skia)
target_link_libraries(emoji skia z)
set_property(TARGET emoji PROPERTY POSITION_INDEPENDENT_CODE ON)

#~~~~~~~

add_custom_target(emoji_combined
  DEPENDS emoji
  SOURCES lib/libemoji.a
)
add_custom_command(
  OUTPUT lib/libemoji.a
  COMMAND ${CMAKE_COMMAND} -E remove -f *.o
  COMMAND ar -x libemoji.a
  COMMAND ar -x libskia.a
  COMMAND ar -qcs libemoji_combined.a *.o
  COMMAND ${CMAKE_COMMAND} -E copy
    ${CMAKE_SOURCE_DIR}/tmp/libemoji_combined.a
    ${CMAKE_SOURCE_DIR}/lib/libemoji.a
  WORKING_DIRECTORY ${CMAKE_SOURCE_DIR}/tmp
)



# Skia
#~~~~~~~~
get_filename_component(gn_path externals/depot_tools/gn ABSOLUTE)
get_filename_component(ninja_path externals/depot_tools/ninja ABSOLUTE)

if(WIN32)
  set(SKIA_NAME "skia.lib")
else()
  set(SKIA_NAME "libskia.a")
endif()

add_custom_target(skia
  SOURCES tmp/${SKIA_NAME}
)
add_custom_command(
  OUTPUT tmp/${SKIA_NAME}
  COMMAND bash ${CMAKE_SOURCE_DIR}/build-skia.sh
  COMMAND ${CMAKE_COMMAND} -E copy ${CMAKE_SOURCE_DIR}/externals/skia/out/Static/${SKIA_NAME} ${CMAKE_SOURCE_DIR}/tmp
  COMMAND ${CMAKE_COMMAND} -E remove_directory ${CMAKE_SOURCE_DIR}/externals/skia/out
  WORKING_DIRECTORY externals/skia
)

# vim: se sw=2 ts=2 sts=2 et ft=cmake :

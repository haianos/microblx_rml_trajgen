CMAKE_MINIMUM_REQUIRED(VERSION 2.6)
project(microblx_rml_trajgen)

set(CMAKE_CXX_FLAGS "-Wall -Werror -fvisibility=hidden")
set( CMAKE_CXX_COMPILER clang++ )
set(CMAKE_MODULE_PATH "${CMAKE_SOURCE_DIR}/cmake")  #temporary

# Global
set(INSTALL_LIB_TYPES_DIR lib/microblx/types CACHE PATH "Installation directory for types libraries")
set(INSTALL_LIB_BLOCKS_DIR lib/microblx/blocks CACHE PATH "Installation directory for blocks libraries")
set(INSTALL_INCLUDE_DIR include/microblx CACHE PATH "Installation directory for header files (types)")
set(INSTALL_CMAKE_DIR  share/microblx/cmake CACHE PATH  "Installation directory for CMake files") # default ${DEF_INSTALL_CMAKE_DIR}

# Local
set(LIBRARY_OUTPUT_PATH ${CMAKE_HOME_DIRECTORY}/lib/ CACHE PATH "Configure the library output path.")
set(EXECUTABLE_OUTPUT_PATH ${CMAKE_HOME_DIRECTORY}/bin/ CACHE PATH "Configure the executable output path.")

##
# Add uninstall target.
##
configure_file(
    "${CMAKE_CURRENT_SOURCE_DIR}/cmake/cmake_uninstall.cmake.in"
    "${CMAKE_CURRENT_BINARY_DIR}/cmake/cmake_uninstall.cmake"
    IMMEDIATE @ONLY)
    
add_custom_target(uninstall
    "${CMAKE_COMMAND}" -P "${CMAKE_CURRENT_BINARY_DIR}/cmake/cmake_uninstall.cmake"
)

set( REFLEXXES_ROOT $ENV{REFLEXXES_ROOT})
if (NOT REFLEXXES_ROOT)
  message( FATAL_ERROR "-- This package requires a Reflexxes installation. \n-- Please define Reflexxes installation folder with REFLEXXES_ROOT Env variable. \n --CMake install will abort." )
else()
  message("Reflexxes Library root should be @  ${REFLEXXES_ROOT}")
  set( REFLEXXES_LIB ${REFLEXXES_ROOT}/Linux/x64/debug/lib/static/libReflexxesTypeII.a)
  set( REFLEXXES_INCLUDE_DIR ${REFLEXXES_ROOT}/include)
endif()


set (UBX_ROOT $ENV{UBX_ROOT} )
if (NOT UBX_ROOT)
 message( FATAL_ERROR "UBX_ROOT is not defined. CMake install willl abort." )
endif()

find_package(Microblx REQUIRED)

include_directories(${UBX_INCLUDE_DIR})
include_directories(${REFLEXXES_INCLUDE_DIR})

add_library(rml_pos SHARED rml_pos.cpp)
set_target_properties(rml_pos PROPERTIES PREFIX "") 
target_link_libraries(rml_pos ${UBX_LIBRARIES} ${REFLEXXES_LIB})

install(TARGETS rml_pos DESTINATION ${INSTALL_LIB_BLOCKS_DIR} EXPORT rml-block)
set_property(TARGET rml_pos PROPERTY INSTALL_RPATH_USE_LINK_PATH TRUE)
install(EXPORT rml-block DESTINATION ${INSTALL_CMAKE_DIR})
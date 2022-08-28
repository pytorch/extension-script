cmake_minimum_required(VERSION 3.1 FATAL_ERROR)
project(example_app)

set(CMAKE_CXX_STANDARD 14)

find_package(Torch REQUIRED)

add_subdirectory(warp_perspective)

add_executable(example_app main.cpp)
target_link_libraries(example_app "${TORCH_LIBRARIES}")
target_link_libraries(example_app -Wl,--no-as-needed warp_perspective)
target_compile_features(example_app PRIVATE cxx_range_for)

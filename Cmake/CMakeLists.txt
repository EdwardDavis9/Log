cmake_minimum_required(VERSION 3.20)
project(Animal CXX)
set(CMAKE_CXX_STANDARD 11)
set(CMAKE_CXX_STANDARD_REQUIRED True)

# -------------------------------------------------------------------------------------------------------
# 方法1
# include(animal/animal.cmake)
# add_executable(Animal main.cpp ${animal_sources})
# -------------------------------------------------------------------------------------------------------

# -------------------------------------------------------------------------------------------------------
# 方法2
# add_subdirectory(animal)
# add_executable(Animal main.cpp)
# target_link_libraries(Animal PUBLIC AnimalLib)
# target_include_directories(Animal PUBLIC ${PROJECT_BINARY_DIR} ${PROJECT_SOURCE_DIR}/animal)
# -------------------------------------------------------------------------------------------------------

# -------------------------------------------------------------------------------------------------------
# 生成库文件
# linux下的静态库是.a文件，对应windows下的.lib文件；
# 而linux下的动态库是.so文件对应windows下的.dll文件
# -------------------------------------------------------------------------------------------------------

# -------------------------------------------------------------------------------------------------------
# option(NO_CONFIG "NO CONFIG" OFF)
# file(GLOB SRC ${PROJECT_SOURCE_DIR}/animal/*.cpp)
# include_directories(${PROJECT_SOURCE_DIR}/include)
# set(LIBRARY_OUTPUT_PATH ${PROJECT_SOURCE_DIR}/a)
# add_library(animal STATIC ${SRC})
# # 静态库的调用流程：1）引入头文件  2）链接静态库  3)生成可执行二进制文件
# include_directories(${PROJECT_SOURCE_DIR}/include)
# link_directories(${PROJECT_SOURCE_DIR}/a)
# link_libraries(animal)
# add_executable(Animal main.cpp)
# -------------------------------------------------------------------------------------------------------


# -------------------------------------------------------------------------------------------------------
# option(NO_CONFIG "NO CONFIG" OFF)
# file(GLOB SRC ${PROJECT_SOURCE_DIR}/animal/*.cpp)
# include_directories(${PROJECT_SOURCE_DIR}/include)
# set(LIBRARY_OUTPUT_PATH ${PROJECT_SOURCE_DIR}/so)
# add_library(animal SHARED ${SRC})
# # 动态库的调用流程：1）引入头文件  2）声明库目录  3)生成可执行文件二进制文件  4）链接动态库
# include_directories(${PROJECT_SOURCE_DIR}/include)
# link_directories(${PROJECT_SOURCE_DIR}/so)
# add_executable(Animal main.cpp)
# target_link_libraries(Animal PUBLIC animal)
# -------------------------------------------------------------------------------------------------------


# -------------------------------------------------------------------------------------------------------
# c++和cmake联动使用
option(NO_CONFIG "NO CONFIG" ON)

configure_file(config.h.in config.h)
add_subdirectory(animal)

add_executable(Animal main.cpp)

target_link_libraries(Animal PUBLIC AnimalLib)
target_include_directories(Animal PUBLIC ${PROJECT_BINARY_DIR} ${PROJECT_SOURCE_DIR}/animal)
# -------------------------------------------------------------------------------------------------------


# -------------------------------------------------------------------------------------------------------
# 说明 PUBLIC INTERFACE PRIVATE 的区别 
# 1. PUBLIC表明本目标需要使用，依赖这个目标的其他目标也需要使用
# 2. INTERFACE表明本目标不使用，依赖本目标的其他目标需要使用
# 3. PRIVATE表明本目标需要使用，依赖本目标的其他目标不需要使用
# -------------------------------------------------------------------------------------------------------

# -------------------------------------------------------------------------------------------------------
# CMake的条件编译
# 通过不同的传入参数，来编译不同的文件
#   1. 用option定义变量 
#   2. 在子CMakeLists.txt中根据变量ON还是OFF来修改SRC(源文件)以及target_compile_definitions
#   3. 修改源文件根据变量选择代码
#   4. 执行命令时，-D<变量>=ON/OFF来进行条件编译
# 见animal目录下的CMakeLists.txt文件
# -------------------------------------------------------------------------------------------------------
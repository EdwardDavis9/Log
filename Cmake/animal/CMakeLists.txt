option(USE_CATTWO "Use Cat Two" ON)

if(USE_CATTWO)
    set(SRC cat.cpp dog.cpp cattwo.cpp)
else()
    set(SRC cat.cpp dog.cpp)
endif()


# add library
add_library(AnimalLib ${SRC})

if(USE_CATTWO)
    target_compile_definitions(AnimalLib PUBLIC USE_CATTWO)
endif()
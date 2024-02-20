# cmake run
# cmake -B build: 生成build目录，makefile文件
# cmake --build build: build整个项目
# build/xxx 即可运行项目
#
# 运行单个cmake文件 test.cmkae
# cmake -P test.cmake
#


# 1 定义变量和打印消息
set(Var1 HELLO-WORLD)
set([[My Var2]] HELLO-WORLD)
message(${Var1})
message(${My\ Var2})

# 在cmake中，‘;’和‘ ’一样， 并且重复定义变量不会报错
set(LISTVALUE a1 a2)
message(${LISTVALUE})
set(LISTVALUE a1;a2)
message(${LISTVALUE})

# 打印系统的环境变量
message(Current\ Path: $ENV{PATH})

set(ENV{CXX} "g++")
message(This\ line\ is\ $ENV{CXX})

unset(ENV{CXX})
message(This\ line\ \ $ENV{CXX})

# 定义变量的两种方式
set(LISTVALUE1 a1 a2)
message(${LISTVALUE1})

list(APPEND LISTVALUE2 0 1 2 3 4 5 6 7 8 9)
message(${LISTVALUE2})
list(LENGTH LISTVALUE2 LEN)
message(length:\ ${LEN})
list(GET LISTVALUE2 0 VAL)
message(get\ 0:\ ${VAL})
list(FIND LISTVALUE2 3 VAL)
message(find:\ ${VAL})
message(${LISTVALUE2})
list(REMOVE_AT LISTVALUE2 1)
message(remove_at:\ ${LISTVALUE2})
list(REMOVE_ITEM LISTVALUE2 8)
message(remove_item:\ ${LISTVALUE2})

list(REVERSE LISTVALUE2)
message(${LISTVALUE2})


list(SORT LISTVALUE2)
message(${LISTVALUE2})
message(-------------------------)


# 2 if判断
set(flag FALSE)
if (flag)
    message(true)
else()
    message(false)
endif()

if(NOT 1 LESS 2)
    message(1\ not\ less\ 2)
else()
    message(1\ less\ 2)
endif()
message(-------------------------)


# 3 foreach循环
foreach(Var RANGE 3)
    message(${Var})
endforeach()

set(MY_LIST 1 2 3)
foreach (VAR IN LISTS MY_LIST ITEMS 4 f)
    message(${VAR})
endforeach ()

# zip
set(list1 one two three four five)
set(list2 1 2 3 4 5)
foreach (num IN ZIP_LISTS list1 list2)
    message("Word=${num_0}, num=${num_1}")
endforeach ()
message(-------------------------)


# 4 function相关
function(Myfunc arg)
    message("Func name: ${CMAKE_CURRENT_FUNCTION}")
    message("First arg: ${arg}")
    set(arg "new Value")
    message("set, Second arg: ${arg}")
    message("Other value 0: ${ARGV0}")
    message("Other value 0: ${ARGV1}")
    message("Other value 0: ${ARGV2}")
    endfunction()

set(var "old value")
message(${var})
Myfunc(${var} "Ohhhhhh")
message(${var})
message(-------------------------)


# 5 scope相关
set(a 1)
function(Outfunction)
    message("  --> ${CMAKE_CURRENT_FUNCTION}: ${a}")
    set(a 2)
    message("  --> ${CMAKE_CURRENT_FUNCTION}: ${a}")
    Infunction()
    message("  <-- ${CMAKE_CURRENT_FUNCTION}: ${a}")
    endfunction()

function(Infunction)
    message("    --> ${CMAKE_CURRENT_FUNCTION}: ${a}")
    set(a 3)
    message("    <-- ${CMAKE_CURRENT_FUNCTION}: ${a}")
endfunction()

# 定义的变量是全局变量, 小作用域内的变量的改变不会覆盖原有变量内容
message("-->: ${a}")
Outfunction()
message("<--: ${a}")
message(-------------------------)


# 6 macro宏函数，类似与C/C++中的宏
set(myVar "old value")

# 宏中的参数是字符串，而函数中的参数是局部变量
#在 CMake 中，宏中的参数被视为字符串，因为它们实际上是在调用宏时进行的字符串替换。
#这意味着在宏中，参数是以字符串的形式传递给宏，并且在宏中被视为字符串。
#你可以将这些参数用于字符串拼接、输出或传递给其他命令，但不能像在函数中一样对它们进行操作。
#
#相比之下，函数中的参数是真正的局部变量。当你在函数中定义参数时，它们就像在其他编程语言中一样的变量。
#你可以对它们进行各种操作，比如进行算术运算、条件判断等。
#函数中的参数的行为更接近于你在其他编程语言中所期望的局部变量行为。

macro(Test myVar)
    message(${myVar})
    set(myVar "new value")
    message(${myVar})
endmacro()

message(before\ ${myVar})
Test(${myVar})
message(after\ ${myVar})

#使用 macro 命令开始录制宏。
#1.宏可以带有参数。
#    宏体内的命令在调用宏时不会立即执行，而是在调用时执行。
#
#2.宏调用不区分大小写。
#    调用宏的方式包括 foo()、Foo()、FOO() 和 cmake_language(CALL foo)。
#
#3.参数传递。
#    在调用宏时，形式参数会被实际参数替换，并执行宏内的命令。
#    特殊变量如 ${ARGC}、${ARGV0}、${ARGV1} 等用于处理宏参数。
#    ${ARGV} 包含所有传递给宏的参数，${ARGN} 包含超出最后一个期望参数的参数。
#
#4.宏与函数的区别。
#    在宏中，ARGN、ARGC、ARGV 等不是真正的变量，而是字符串替换。
#    宏的控制流不同于函数，宏被执行后会返回到宏调用的范围。
#    宏中的 return() 并不终止宏的执行。
#
#5.参数注意事项。
#    由于宏参数不是真正的变量，不能像变量一样使用条件语句和循环语句。
#    应使用特殊变量 ${ARGC} 检查可选参数的传递情况。
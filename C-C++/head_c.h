#pragma once
#include <stdio.h>
#include <stdlib.h>

#ifdef __cplusplus
extern "C" {
#endif
// 这种写法告诉C++编译器，printfNum函数使用的是C的调用约定，可以直接在C++ 中调用
void printfNum(int);

#ifdef __cplusplus
}
#endif
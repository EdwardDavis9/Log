//
// Created by cam on 2022/12/22.
//

#include <iostream>

namespace book
{
    int price = 10;
}

int money = 100;

// 引用，范围for循环, auto
void for_each(auto&);

int main_one()
{
    //通过using可以使用命名空间
    //通过using也可以做typedef
    # if 1
    using myInt = int;
    myInt money = 20;
    std::cout << "myInt local money = " << money << std::endl; //当前作用域下
    std::cout << "int global money = " << ::money << std::endl; //全局作用域下
    # endif

    int five = 5;
    char fiveChar[five] = {'f', 'i', 'v', 'e', '\0'};
    std::cout << fiveChar << std::endl;

    int month[5] = {1, 2, 3, 4, 0};
    int (&Arr)[5] = month;

    for_each(month);
    putchar('\n');
    Arr[2] = 6;

//    for_each
    for_each(Arr);


    putchar('\n');

//  从外部文件导入变量a
    extern int extern_a;
    std::cout << "import extern_a from outfile: " << extern_a << std::endl;



    return 0;
}


void for_each(auto &arr) {
    /*
     int &i;
    所有的引用本身都是顶层 const，因为引用一旦初始化就不能再改为其他对象的引用

    看指针*的修饰对象，*右边是const，那么就是顶层const
    int * const ppp      = 321;//顶层const
    看指针*的修饰对象，*右边是变量类型，那么就是底层const
    const int * pp = 123;//底层const
     */

    for(auto& i : arr)
    {
        if(i == 0)
           break;
        std::cout << "month: " << i << " ";
    }

}

/*
 * 个人理解：
 *  C比C++更底层，更直接，c中操作的是值相关的，而c++中操作的是地址相关的，C++在C的基础上进行了又一次封装
 *
 *  在C中数组的创建必须是一个直接量，如int arr[5]
 *  int a = 5;
 *  int arr[a];
 *  会报错，只需明确指出一个值，而C++中则可以
 *
 *  如C中的const只是对值的const, C++中的const是对地址的const
 *  换言之，在C中const修饰的变量仅仅是对值的限制，但可以通过地址修改
 *  而在C++中const修饰的变量不仅是对值的限制，而且也是对地址的限制
 *
 *  除此之外还有其他更多的操作
 */

// c++ 中对类型匹配更加严格，且进行对代码严格检查
//1、全局变量检测增强
int a;
//int a = 10; //不可以重复定义a

//2、函数检测增强
//int getRectS(w, h) {}
//void test02() { getRectS(10, 10, 10); }

//3、类型转换检测增强
void test03() { char * p = (char*)malloc(sizeof(64)); delete(p); /*malloc返回值是void, 所以在c++中，要显示转换类型*/ }

//4、struct 增强，c语言中struct不可以加函数
struct Person {
    int m_Age;
    void plusAge();
};


//5、 bool类型增强 C语言中没有bool类型
bool flag;

//6、三目运算符增强
void test06()
{
    int a = 10;
    int b = 20;
    printf("ret = %d \n", a > b ? a : b);
    //a > b ? a : b = 100; // 20 = 100 C++中返回可以引用

    //C语言中想模仿C++写
    *(a > b ? &a : &b) = 100;
    printf("a = %d ,b = %d \n", a, b);
};

//7、 const增强
const int m_A = 10; //c++中是真正的常量，不可以改
void test07()
{
//    m_A = 100;
//    const int m_B = 20; //c中伪常量
//    m_B = 100;

//    int * p = (int *)&m_B;
//    *p = 200;
//    printf("*p = %d , m_B = %d \n", *p, m_B);
};
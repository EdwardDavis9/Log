# Makefile 规则
#
# 目标:依赖
# (TAB)命令
#
# gcc中，-L是添加库的路径，-l是添加待链接的库，-I是指定待包含的头文件
#
#---------------------------------------------------------------------------------

# 对自带变量进行赋值
CC = gcc
CPPFFLAGS = -I./

# 查找当前目录下指定的类型文件， 并赋值给src
src = $(wildcard *.c)

# 把src变量中所有后缀为.c的文件更换为以.o为后缀的文件
objects = $(patsubst %.c, %.o, $(src))
# objects = main.o fun1.o fun2.o sum.o

target = main

# '$@' 指的是目标
# '$<'指的是依赖中的第一个条件
# '$^'指的的是依赖中的所有条件
# 第一个目标，默认只执行第一个终极目标，当加载这个目标时若出现了其他依赖，则会去执行其他依赖条件
$(target): $(objects)
	$(CC) -o $@  $^

%.o: %.c
	$(CC) -g -c $< -o $@ $(CPPFLAGS) # -g生成gdb调试信息， -c生成.o文件

# 第二个目标，在make时可指定这个目标执行
# -符号用于忽略命令执行过程中的错误
.PHONY:clean #设置为伪目标后，makefile将不检查该目标是否存在或者该目标是否需要更新
clean:
	-rm -f $(objects) $(target) 

#main.o: main.c
#	$(CC) -c $< -I./
#
#fun1.o :fun1.c
#	gcc -c $< 
#
#fun2.o: fun2.c
#	gcc -c $<
#
#sum.o: sum.c
#	gcc -c $<

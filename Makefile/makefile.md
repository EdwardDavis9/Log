
# Makefile 学习记录

---

[back](../README.md)
## 什么是 Makefile？

Makefile 是一个用于自动化构建和管理项目的工具。它通常由一系列规则组成，每个规则指定了如何生成一个或多个目标文件。

## Makefile 的基本语法

Makefile 的基本语法由目标（target）、依赖关系（dependencies）和命令组成。

一个基本的规则结构如下：

``` makefile
target: dependencies
    command
```

- `target` 是要构建的目标文件。
- `dependencies` 是 `target` 所依赖的文件或其他目标。
- `command` 是生成 `target` 的命令

## 简单的示例

假设有一个项目，包含两个源文件 `main.c` 和 `other.c`，我们想要将它们编译成一个可执行文件 `program`。

我们可以编写一个简单的 Makefile 如下：

``` makefile
app: main.o other.o
    gcc -o program main.o other.o

main.o: main.c
    gcc -c main.c

other.o: other.c
    gcc -c other.c
```

这个 Makefile 包含了三个规则：

- `app` 是我们的目标，它依赖于 `main.o` 和 `other.o`，当这两个文件更新时，我们需要重新生成 `app`。
- `main.o` 依赖于 `main.c`，当 `main.c` 更新时，我们需要重新编译 `main.o`。
- `other.o` 依赖于 `other.c`，当 `other.c` 更新时，我们需要重新编译 `other.o`。

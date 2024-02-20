#include <iostream>

#ifdef NO_CONFIG
#include "config.h"
#endif
#include "include/Cat.h"
#include "include/Dog.h"

int main() {
  Cat cat;
  std::cout << cat.barking() << std::endl;

  Dog dog;
  std::cout << dog.barking() << std::endl;

#ifdef NO_CONFIG
  std::cout << "CMAKE_CXX_STANDARD: " << CMAKE_CXX_STANDARD << std::endl;
#endif

  return 0;
}
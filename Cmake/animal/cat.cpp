#include "../include/Cat.h"

#ifdef USE_CATTWO
#include "../include/cattwo.h"
#endif

std::string Cat::barking() {
#ifdef USE_CATTWO
  return cattwo::two();//条件编译
#else
  return "非条件编译：miao miao~~";
#endif
}
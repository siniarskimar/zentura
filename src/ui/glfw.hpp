#ifndef GLFW_LIBRARY_H
#define GLFW_LIBRARY_H
#pragma once

#include <GLFW/glfw3.h>

class GLFW {
public:
  static bool initialize();
  static bool isInitialized();
  static void terminate();
};

#endif

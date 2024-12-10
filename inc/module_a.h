#include "systemc.h"

SC_MODULE(module_a) {
  void run() {
    cout << "Hello World!" << endl;
  }
  SC_CTOR(module_a) {
    SC_THREAD(run);
  }
};
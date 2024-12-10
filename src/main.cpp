#include "systemc.h"

#include "module_a.h"

int sc_main(int, char *[])
{
    module_a *i_module_a = new module_a("i_module_a");
    sc_start(500, SC_NS);
    return 0;
}
#ifndef CSA_H
#define CSA_H

#include <systemc.h>

#define SIZE 8

SC_MODULE(CSA)
{
    // Ports
    sc_in<sc_uint<SIZE>> B_input;
    sc_in<sc_uint<SIZE>> A_input;
    sc_in<sc_uint<SIZE>> S_input;
    sc_in<sc_uint<SIZE>> carry_in;

    sc_out<sc_uint<SIZE>> carry_out;
    sc_out<sc_uint<SIZE>> sum_out;
    sc_out<sc_uint<SIZE>> lsb_out;

    // Method Declaration
    void CSA_method();

    SC_CTOR(CSA)
    {
        SC_METHOD(CSA_method);
        dont_initialize(); // Don't execute on initialization
        sensitive << A_input << B_input << S_input << carry_in;
    }
};

#endif


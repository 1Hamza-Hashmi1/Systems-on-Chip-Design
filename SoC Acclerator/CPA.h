#ifndef CPA_H
#define CPA_H

#include <systemc.h>
#include "CSA.h"

#ifndef SIZE
#define SIZE 8
#endif

SC_MODULE(CPA)
{
    // Inputs
    sc_in<sc_uint<SIZE>> B_input;      // Input B
    sc_in<sc_uint<SIZE>> A_input;      // Input A
    sc_in<sc_uint<SIZE>> carry_in;     // Carry-in for the CPA
    sc_in<sc_uint<SIZE>> least_sig;    // Least Significant Bit Input

    // Outputs
    sc_out<sc_uint<SIZE>> carry_out;   // Carry-out from the CPA
    sc_out<sc_uint<SIZE>> sum_out;     // Sum output from the CPA

    sc_out<sc_uint<SIZE>> lsb_out;     // Least Significant Bits output
    sc_out<sc_uint<SIZE>> sum_out_csa; // Sum output from CSA
    sc_out<sc_uint<SIZE>> carry_out_csa; // Carry output from CSA

    sc_out<sc_uint<SIZE>> msb_out;     // Most Significant Bits output
    sc_out<sc_uint<SIZE * 2>> complete; // Complete product output

    // CPA method definition
    void CPA_method();

    // Constructor
    SC_CTOR(CPA)
    {
        // Register the CPA method with SystemC
        SC_METHOD(CPA_method);
        dont_initialize(); // Prevent method execution on initialization
        // Sensitive to changes in the following signals
        sensitive << A_input << B_input << carry_in << least_sig;
    }
};

#endif

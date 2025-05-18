// Main cpp
#include <systemc.h>
#include "CSA.h"
#include "CPA.h"

#ifndef SIZE
#define SIZE 8
#endif

int sc_main(int argc, char *argv[])
{
    sc_trace_file *tf; // Create VCD file for tracing

    // Signals
    sc_signal<sc_uint<SIZE>> sum_cpa;
    sc_signal<sc_uint<SIZE>> carryout_cpa;
    sc_signal<sc_uint<SIZE>> ain_cpa;
    sc_signal<sc_uint<SIZE>> bin_cpa;
    sc_signal<sc_uint<SIZE>> carryin_cpa;

    sc_signal<sc_uint<SIZE>> lsb_out_cpa;
    sc_signal<sc_uint<SIZE>> sum_out_csa;
    sc_signal<sc_uint<SIZE>> carry_out_csa;

    sc_signal<sc_uint<SIZE>> msb_out_cpa;
    sc_signal<sc_uint<SIZE>> lsb_in_cpa;
    sc_signal<sc_uint<SIZE * 2>> product;

    sc_clock clk("clk", 10, SC_NS, 0.5); // Create a clock signal

    // Device Under Test (DUT)
    CPA cpa_instance("CPA");

    cpa_instance.B_input(bin_cpa);
    cpa_instance.A_input(ain_cpa);
    cpa_instance.carry_in(carryin_cpa);
    cpa_instance.carry_out(carryout_cpa);
    cpa_instance.sum_out(sum_cpa);

    cpa_instance.lsb_out(lsb_out_cpa);
    cpa_instance.sum_out_csa(sum_out_csa);
    cpa_instance.carry_out_csa(carry_out_csa);

    cpa_instance.msb_out(msb_out_cpa);
    cpa_instance.complete(product);
    cpa_instance.least_sig(lsb_in_cpa);

    // Create wave file and trace signals
    tf = sc_create_vcd_trace_file("trace_file");
    if (!tf) {
        std::cerr << "Error: Unable to create VCD trace file." << std::endl;
        return -1;
    }

    tf->set_time_unit(1, SC_NS);

    sc_trace(tf, msb_out_cpa, "MSB_output_cpa");
    sc_trace(tf, product, "Product");
    sc_trace(tf, sum_out_csa, "Sum_CSA_output");
    sc_trace(tf, carry_out_csa, "Carry_CSA_output");
    sc_trace(tf, bin_cpa, "B_input_whole_module");
    sc_trace(tf, ain_cpa, "A_input_whole_module");
    sc_trace(tf, lsb_out_cpa, "LSB_output_cpa");

    std::cout << "\nExecuting Array Multiplier DUT... check .vcd produced" << std::endl;

    // Test cases
    ain_cpa.write(3);
    bin_cpa.write(2);
    sc_start(20, SC_NS);

    ain_cpa.write(0);
    bin_cpa.write(44);
    sc_start(20, SC_NS);

    ain_cpa.write(9);
    bin_cpa.write(9);
    sc_start(20, SC_NS);

    ain_cpa.write(255);
    bin_cpa.write(255);
    sc_start(20, SC_NS);

    sc_close_vcd_trace_file(tf);

    return 0;
}

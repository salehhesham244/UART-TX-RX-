module TX_Wrapper (

    input clk,
    input rst,
    input data_valid,
    input [7:0] p_data,
    input par_en,
    input par_typ,
    output logic tx_out,
    output logic busy

);

/*Define the entire Registers*/
bit       ser_en_reg,ser_done_reg,ser_data_reg;
bit       par_bit_reg;
bit [2:0] sel;

/*Instantiate the modules*/
Serializer  Serial (clk, rst, data_valid, ser_en_reg, busy, p_data, ser_done_reg, ser_data_reg );
Parity_Calc Parity (data_valid, par_typ, p_data, par_bit_reg );
FSM         tx_DUT (clk, rst, data_valid, par_en, ser_done_reg, sel, ser_en_reg, busy );
MUX_4x1     mux    (clk,rst,sel, ser_data_reg, par_bit_reg, tx_out );


endmodule //TX_Wrapper
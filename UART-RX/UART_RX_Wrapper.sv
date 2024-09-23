module UART_RX_Wrapper(

    input  bit clk,
    input  bit rst_n,
    input  bit test_validity,
    input  bit RX_IN,
    input  bit PAR_EN,
    input  bit PAR_TYP,
    input  int prescale,
    output bit data_valid,
    output bit [10:0] P_DATA

);

bit en,dat_en,samp_bit,des_en,par_chk_enable,strt_chk_enable,stp_chk_enable;
bit start_err,stop_err,parity_err,rmv_data;
bit [3:0] bit_counter,edge_counter;

FSM fsm_DUT (.test_validity(test_validity), .remove_data(rmv_data), .clk(clk), .rst(rst_n), .bit_cnt(bit_counter), .edge_cnt(edge_counter), .par_en(PAR_EN), .prescale(prescale), .RX_IN(RX_IN), .par_err(parity_err), .stp_err(stop_err),
             .strt_glitch(start_err), .enable(en), .dat_samp_en(dat_en), .data_valid(data_valid), .deser_en(des_en), .par_chk_en(par_chk_enable), .strt_chk_en(strt_chk_enable), .stp_chk_en(stp_chk_enable) );
edge_bit_counter counter_dut (.clk(clk), .enable(en), .prescale(prescale), .bit_cnt(bit_counter), .edge_cnt(edge_counter) );
data_sampling data_sampling_dut (.prescale(prescale), .edge_cnt(edge_counter), .dat_samp_en(dat_en), .RX_IN(RX_IN), .sampled_bit(samp_bit) );
deserializer deser_dut (.remove_data(rmv_data), .par_en(PAR_EN), .deser_en(des_en), .sampled_bit(samp_bit), .P_Data(P_DATA) );
Parity_Check parity_chk_dut (.par_typ(PAR_TYP), .par_chk_en(par_chk_enable), .sampled_bit(samp_bit), .par_err(parity_err) );
Stop_Check stop_chk_dut (.stp_chk_en(stp_chk_enable), .sampled_bit(samp_bit), .stp_err(stop_err) );
Strt_Check start_chk_dut (.strt_chk_en(strt_chk_enable), .sampled_bit(samp_bit), .strt_glitch(start_err) );

endmodule
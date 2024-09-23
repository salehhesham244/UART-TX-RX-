`define NO_ERROR  1
`define ERROR     0
module FSM #(

    parameter IDLE    = 3'b000,
    parameter START   = 3'b001,
    parameter DATA    = 3'b010,
    parameter PARITY  = 3'b011,
    parameter STOP    = 3'b100

)(
   
    input  bit clk,              // The clk of the design.
    input  bit rst,              // The reset of the design to the default values.
    input  bit test_validity,
    input  bit [3:0] bit_cnt,    // To transfer from one state to another depending on which bit we are.
    input  bit [3:0] edge_cnt,   // To turn on the enables of check errors and then turn them of.
    input  bit par_en,           // To check if there is a parity bit or not.
    input  int prescale,         // To specify if work on 8 or 16 prescale.
    input  bit RX_IN,            // The input data on the line.
    input  bit par_err,          // The flag that tell us there is error in the parity bit.
    input  bit stp_err,          // The flag that tell us there is error in the stop bit.
    input  bit strt_glitch,      // The flag that tell us there is error in the start bit.
    output bit enable,           // The enable of edge bit counter.
    output bit dat_samp_en,      // The enable of data sampling.
    output bit data_valid,       // The flag which tell us that the data has sent is vaild.
    output bit deser_en,         // The enable of the deserializer.
    output bit par_chk_en,       // The enable of the parity bit checker.
    output bit strt_chk_en,      // The enable of the start bit checker.
    output bit stp_chk_en,        // The enable of the stop bit checker.
    output bit remove_data       // To remove the data from the deserializer to start new one.

);
    
  logic [2:0] ns,cs;             // The curent and next state pointers.
 
 /* The State-Memory-Machine */
  always @(posedge clk or negedge rst) begin
        if (!rst) begin
            cs          = IDLE;
            data_valid  = 1'b0;
            deser_en    = 1'b0;
            par_chk_en  = 1'b0;
            strt_chk_en = 1'b0;
            stp_chk_en  = 1'b0;
        end
        else begin
            cs <= ns;
        end
  end

  /* The Next-State-Logic */
  always @(cs,RX_IN,bit_cnt,par_en) begin
     case (cs)
        IDLE:begin
            if (RX_IN==1'b0) begin
                ns=START;
            end
        end
        START:begin;
            if (bit_cnt==4'b0001) begin
                ns=DATA;
            end
        end 
        DATA:begin
            if (par_en==1'b1) begin
                if (bit_cnt==4'b1001) begin
                    ns=PARITY;
                end
            end
            else begin
               if (bit_cnt==4'b1001) begin
                    ns=STOP;
                end 
            end
        end
        PARITY:begin
            if (bit_cnt==4'b1010) begin
                    ns=STOP;
            end
        end
        STOP:begin
            if (bit_cnt==4'b0000) begin
                ns=IDLE;
            end
        end
        default: ns=IDLE; 
     endcase
  end

  /* The OutPut-Logic */
  always @(*) begin
        /* To make sure that each bit sampled for just one time  */
        if (edge_cnt==5) begin
            deser_en=1'b1;
        end
        else begin
            deser_en=1'b0;
        end
        case (cs)
            IDLE:begin
                remove_data=1'b1;
                if (RX_IN==1'b0) begin
                    enable=1'b1;
                    dat_samp_en=1'b1;
                end
            end
            START:begin
                remove_data=1'b0;
                if (edge_cnt==7) begin
                    strt_chk_en=1'b1;
                end
                else begin
                    strt_chk_en=1'b0;
                end
            end
            PARITY:begin
                if (edge_cnt==5) begin
                    par_chk_en=1'b1;
                end
                else begin
                    par_chk_en=1'b0;
                end
            end
            STOP:begin
                if (edge_cnt==5) begin
                    stp_chk_en=1'b1;
                end
                else begin
                    stp_chk_en=1'b0;
                end
                if (edge_cnt==7) begin
                    enable=1'b0;
                    dat_samp_en=1'b0;
                end
            end   
            default: begin
                if (cs==STOP && edge_cnt==7) begin
                    enable=1'b0;
                    dat_samp_en=1'b0;
                end
            end
        endcase
        if (par_en==1'b1 && test_validity==1'b1 ) begin
                if (stp_err==`NO_ERROR && strt_glitch==`NO_ERROR && par_err==`NO_ERROR) begin
                data_valid=1'b1;
                end
                else begin
                    data_valid=1'b0;
                end
        end
        else if (test_validity==1'b1) begin
            if (stp_err==`NO_ERROR && strt_glitch==`NO_ERROR ) begin
                data_valid=1'b1;
            end
            else begin
                data_valid=1'b0;
            end
        end
         
  end

endmodule
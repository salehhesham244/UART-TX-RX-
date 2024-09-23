`define NO_ERROR  1
`define ERROR     0
`define START_BIT 0

module Strt_Check(
    
    input  bit strt_chk_en,
    input  bit sampled_bit,
    output logic strt_glitch

);
    
    always @(*) begin
        if (strt_chk_en==1'b1) begin
            if (sampled_bit==`START_BIT) begin
                strt_glitch=`NO_ERROR;
            end
            else begin
                strt_glitch=`ERROR;
            end
        end
    end
endmodule
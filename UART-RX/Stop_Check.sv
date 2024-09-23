`define NO_ERROR  1
`define ERROR     0
`define STOP_BIT 1

module Stop_Check(
    
    input  bit stp_chk_en,
    input  bit sampled_bit,
    output logic stp_err

);
    
    always @(*) begin
        if (stp_chk_en==1'b1) begin
            if (sampled_bit==`STOP_BIT) begin
                stp_err=`NO_ERROR;
            end
            else begin
                stp_err=`ERROR;
            end
        end
    end
endmodule
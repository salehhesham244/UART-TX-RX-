`define NO_ERROR 1
`define ERROR    0
`define EVEN_PARITY 0
`define ODD_PARITY 1

module Parity_Check #(

    parameter WIDTH = 8

)(
    
    input  bit   par_typ,
    input  bit   par_chk_en,
    input  bit   sampled_bit,
    output logic par_err

);
    
    bit [WIDTH:0] data;
    bit parity_calc;
    int counter=0;

    always @(*) begin

        data[counter++]=sampled_bit;
       
        if (counter==9) begin
            counter=0;
        end
       
        if (par_typ==`EVEN_PARITY) begin
            parity_calc=^data[WIDTH:1];
        end
        else begin
            parity_calc=(~(^data[WIDTH:1]));
        end
        if (par_chk_en==1'b1) begin
            if (sampled_bit==parity_calc) begin
                par_err=`NO_ERROR;
            end
            else begin
                par_err=`ERROR;
            end
        end
    end

endmodule
module MUX_4x1 (
    input clk,
    input rst_n,
    input [2:0] mux_sel,
    input ser_data,
    input par_bit,
    output reg TX_out
);

localparam start_bit =1'b0 ;
localparam stop_bit  =1'b1;

always @ (posedge clk or negedge rst_n) begin
 if (!rst_n) begin
    TX_out=1;
 end
 else begin
    case (mux_sel)
        2'b00:begin
            TX_out=start_bit;
        end
        2'b01:begin
            TX_out=ser_data;
        end
        2'b10:begin
            TX_out=par_bit;
        end
        2'b11:begin
            TX_out=stop_bit;
        end  
        default: TX_out=1;
    endcase
 end
end

endmodule //4x1MUX
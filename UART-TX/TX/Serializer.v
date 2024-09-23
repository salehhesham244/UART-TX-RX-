module Serializer (
    input             clk,
    input             rstn,
    input             Data_valid,
    input             ser_en,
    input             busy,
    input  wire [7:0] P_data,
    output reg        ser_done,
    output reg        ser_data
);

reg [7:0] P_data_reg;
reg [2:0] counter=0;
reg       activate=0;

always @(posedge clk or negedge rstn) begin
    if (!rstn) begin
        P_data_reg <= 0;
        ser_done <=0;
    end
    else begin  
      
        if ( Data_valid==1'b1 ) begin
        
            activate=1'b1;
            P_data_reg=P_data;
        
        end
        else begin
            activate=1'b0;
        end
        if (activate==1'b1) begin
            
            if (ser_en) begin
                ser_data=(P_data_reg>>(1'b0 + counter));
                counter<=counter+1'b1;
            end

            if (counter==3'h8) begin
                counter=1'b0;
                ser_done=1'b1;
                activate=1'b0;
            end
        end
    end
end

endmodule //Serializer
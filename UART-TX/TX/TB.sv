module TB ();

bit clk,rst,data_valid,parity_en,parity_type,tx_out,busy;
bit [7:0] data;
int i;

TX_Wrapper DUT (clk,rst,data_valid,data,parity_en,parity_type,tx_out,busy);

initial begin
    clk=0;
    forever begin
        #1 clk=~clk;
    end
end

initial begin
    rst=0;
    data_valid=0;
    parity_en=0;
    parity_type=0;
    data=0;
    #10 
    rst=1;
    #10;
    for (i=0;i<100;i=i+1) begin
        #5;
        if (i<25) begin
            data_valid=1;
            data=8'b10101010;
            parity_en=1;
            parity_type=1;
        end  
        else if (i<50) begin
            data_valid=1;
            data=8'b01010101;
            parity_en=1;
            parity_type=0;
        end
        else if (i<53) begin
            data_valid=0;
        end
        else if (i<100) begin
            data_valid=1;
            data=8'b10101010;
            parity_en=0;
            parity_type=0;
        end
    end
    #50 $stop;
end

initial begin
    $monitor ("%t:rst=%0d, data_valid=%0d, Data=%0b, Parity_EN=%0d, Parity_type=%0d, Tx_out=%0d, busy=%0d",$time,rst,data_valid,data,parity_en,parity_type,tx_out,busy);
end

endmodule //TB
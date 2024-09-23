module TB();
    
    bit clk;
    bit divided_clk;
    bit test_validity;
    bit rst;
    bit par_en;
    bit par_typ;
    bit RX_IN;
    int prescale;
    bit data_valid;
    bit [10:0] Parallel_DATA;

UART_RX_Wrapper wrapper_dut (.test_validity(test_validity), .clk(divided_clk), .rst_n(rst), .RX_IN(RX_IN), .PAR_EN(par_en), .PAR_TYP(par_typ), .prescale(prescale), .data_valid(data_valid), .P_DATA(Parallel_DATA) );

    initial begin
       clk=0;
       forever begin
        #8 clk=~clk;
        end
    end

    initial begin
        divided_clk=0;
        forever begin
            #1 divided_clk=~divided_clk;
        end
    end
    //review the delays and look inside the blocks.
    initial begin
        
         rst=1'b0;
        #10;
        rst=1'b1;
        #10;
        par_en=1'b1;
        par_typ=1'b0;
        prescale=8;
        //start_bit.
        RX_IN=1'b0;
         @ (negedge clk);
        //start of data '1111_1111'
        RX_IN=1'b1;
         @ (negedge clk);
        RX_IN=1'b1;
         @ (negedge clk);
        RX_IN=1'b1;
         @ (negedge clk);
        RX_IN=1'b1;
         @ (negedge clk);
        RX_IN=1'b1;
         @ (negedge clk);
        RX_IN=1'b1;
         @ (negedge clk);
        RX_IN=1'b1;
         @ (negedge clk);
        RX_IN=1'b1;
         @ (negedge clk);
        RX_IN=1'b0;
         @ (negedge clk);
        //Sending the Stop_bit.
        RX_IN=1'b1;
        test_validity=1'b1;

                                                             /* The timing affect the reult here */
        
        #25;
        
        // Test sending while the par_en is de-active.
         $display("Test sending while the par_en is de-active");
        par_en=1'b0;
        par_typ=1'b0;
        //start_bit.
        RX_IN=1'b0;
         @ (negedge clk);
        //start of data '1111_1111'
        RX_IN=1'b1;
         @ (negedge clk);
        RX_IN=1'b1;
         @ (negedge clk);
        RX_IN=1'b1;
         @ (negedge clk);
        RX_IN=1'b1;
        @ (negedge clk);
        RX_IN=1'b1;
        @ (negedge clk);
        RX_IN=1'b1;
        @ (negedge clk);
        RX_IN=1'b1;
        @ (negedge clk);
        RX_IN=1'b1;
        @ (negedge clk);
        RX_IN=1'b1;
        test_validity=1'b1;
         
        #80 $stop;
    end

    initial begin
        $monitor ("%t:par_en=%d, par_typ=%d, RX_IN=%d, Prescale=%d, Data_valid=%d, Parallel_DATA=%b",$time,par_en,par_typ,RX_IN,prescale,data_valid,Parallel_DATA);
    end

endmodule
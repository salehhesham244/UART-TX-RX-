module edge_bit_counter (

            input  bit clk,
            input  bit enable,
            input  int prescale,
            output logic [3:0] bit_cnt,
            output logic [3:0] edge_cnt

);

    int bit_counter=0;
    int edge_counter=0;

    always @(posedge clk) begin
        if (enable==1'b1) begin
            if (prescale==8) begin
                edge_counter++;
                if (edge_counter==8) begin
                    bit_counter++;
                    edge_counter=0;
                end
                else if (edge_counter==7 &&bit_counter==10) begin
                    bit_counter=0;
                end
            end
            else if (prescale==16) begin
                edge_counter++;
                if (edge_counter==16) begin
                    bit_counter++;
                    edge_counter=0;
                end
                if (edge_counter==15 &&bit_counter==10) begin
                    bit_counter=0;
                end
            end
        end
    end

    assign edge_cnt = edge_counter ;
    assign bit_cnt  = bit_counter  ;

endmodule
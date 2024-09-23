module data_sampling (
    
        input  int   prescale,
        input  bit   [3:0] edge_cnt,
        input  bit   dat_samp_en,
        input  bit   RX_IN,
        output logic sampled_bit

);

    bit first_sampled;
    bit sec_sampled;
    bit third_sampled;

    always @(*) begin
        /* Start to sample data if we get the enable from the FSM */
        if (dat_samp_en) begin
            /* If the prescale is equal to 8 so we will sample the data three time at the mid of it (3,4,5) */
            if (prescale==8) begin
                if (edge_cnt==4'b0011) begin
                    first_sampled=RX_IN;
                end
                else if (edge_cnt==4'b0100) begin
                    sec_sampled=RX_IN;
                end
                else if (edge_cnt==4'b0101) begin
                    third_sampled=RX_IN;
                    get_majority(first_sampled,sec_sampled,third_sampled);
                end
            end
            /* If the prescale is equal to 16 so we will sample the data three time at the mid of it (8,9,10) */
            else if (prescale==16) begin
                if (edge_cnt==4'b1000) begin
                    first_sampled=RX_IN;
                end
                else if (edge_cnt==4'b1001) begin
                    sec_sampled=RX_IN;
                end
                else if (edge_cnt==4'b1010) begin
                    third_sampled=RX_IN;
                    get_majority(first_sampled,sec_sampled,third_sampled);
                end
            end
        end
    end
    /* Task to calculate the majority of the three sampled bits */
    task get_majority (bit first_bit ,bit sec_bit, bit third_bit);
        if (first_bit==sec_bit) begin
            sampled_bit=first_bit;
        end
        else if (sec_bit==third_bit) begin
            sampled_bit=sec_bit;
        end
        else if (first_bit==third_bit) begin
            sampled_bit=third_bit;
        end
    endtask
    
endmodule
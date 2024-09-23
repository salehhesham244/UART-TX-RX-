module deserializer #(

    parameter WIDTH = 11

)(
    
    input  bit par_en,
    input  bit deser_en,
    input  bit sampled_bit,
    input  bit remove_data,
    output logic [WIDTH-1:0] P_Data

);
    

    always @(*) begin
        if (deser_en==1'b1) begin
            if (par_en==1'b1) begin
                /* Thats mean our frame consist of 11-bits */
                P_Data={P_Data,sampled_bit};
            end
            else begin
                /* Thats mean our frame consist of 10-bits */
                P_Data={P_Data,sampled_bit};   
            end
        end
        if (remove_data==1'b1) begin
            P_Data=0;
        end
end
endmodule
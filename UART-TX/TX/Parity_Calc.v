module Parity_Calc (
    input Data_valid,
    input Par_typ,
    input [7:0] P_Data,
    output reg Par_bit
);

always @(*) begin

    //If data_valid is high that's mean there's parallel data in.

    if (Data_valid) begin

        //Calculate odd parity.

        if (Par_typ) begin

            Par_bit=~(^P_Data);

        end

        //Calculate even parity.

        else begin

            Par_bit=^(P_Data);

        end
    end
end

endmodule //Parity_Calc
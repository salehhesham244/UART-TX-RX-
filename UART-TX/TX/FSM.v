module FSM #( 

parameter IDLE   = 4'h0,
parameter START  = 4'h1,
parameter DATA   = 4'h2,
parameter PARITY = 4'h3,
parameter STOP   = 4'h4

)(

    input      clk,
    input      rstn,
    input      Data_valid,
    input      par_en,
    input      ser_done,
    output reg [2:0]mux_sel,
    output reg ser_en, 
    output reg busy

);

reg [2:0] cs,ns;

//State Memory logic 
always @(posedge clk or negedge rstn) begin
   
    if (!rstn) begin
        cs<=1'b0;
    end
    else begin
        cs<=ns;
    end

end

//Next State Logic
always @(*) begin
    
    case (cs)

        IDLE:begin
           if (Data_valid) begin
            ns=START;
           end  
           else
           ns=IDLE;      
        end
        
        START:begin
            ns=DATA;
        end

        DATA:begin
            #16;
           if (ser_done) begin
              if (par_en==1'b1) begin
                 ns=PARITY;
               end
               else begin
                  ns=STOP;
               end
            end
            else begin
                ns=DATA;
            end
        end

        PARITY:begin
            ns=STOP;
        end

        STOP:begin
            ns=IDLE;
        end
        default: begin
            ns=IDLE;
        end
    endcase

end

// Output logic
always @(*) begin
   
    case (cs)
         IDLE: begin
            mux_sel =3'b111;
         end
         START:begin
           mux_sel = 2'b00;
           busy    = 1'b1;
         end
         
         DATA:begin
           mux_sel =2'b01;
           ser_en  = 1'b1;
         end
         
         PARITY:begin
           mux_sel=2'b10;
           #1;
         end

         STOP:begin
           mux_sel=2'b11;
           ser_en  = 1'b0;
           busy    = 1'b0;
         end
        

    endcase

end


endmodule //FSM
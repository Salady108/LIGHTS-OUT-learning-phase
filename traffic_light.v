module traffic_light(input clk,input reset_n,input [1:0]color,output [2:0]action);
    reg [2:0] action;
    wire [1:0] color;
    reg [2:0] state,next_state;
    parameter red=2'b00,
              green=2'b01,
              yellow=2'b10;
    always@(posedge clk or negedge reset_n)begin
        if(!reset_n)
        state<=red;
        else
        state<=next_state;
    end 
    always@(state)begin
        case(state)
        red:next_state=color;
        green:next_state=color;
        yellow:next_state=color;
        default:next_state=color;
        endcase 
    end
    always@(state)begin
        action=3'b011;
        case(state)
        red:action=3'b011;
        yellow:action=3'b100;
        green:action=3'b101;
        
        endcase
    end
endmodule
        

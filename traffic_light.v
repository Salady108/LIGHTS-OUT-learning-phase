module traffic_light(input clk,input reset_n,input color,output action);
    reg [2:0] action;
    wire [2:0] color;
    reg [2:0] state,next_State;
    parameter red=3'b000,
              green=3'b001,
              yellow=3'b010;
    always@(posedge clk or negedge reset_n)begin
        if(!reset_n)
        state<=red;
        else
        state<=next_State;
    end 
    always@(state)begin
        case(state)
        red:next_state=color;
        green:next_State=color;
        yellow:next_State=color;
        default:next_State=color;
        endcase 
    end
    always@begin(state)begin
        action=3'b011;
        case(state)
        red:action=3'b011;
        yellow:action=3'b100;
        green:action=3'b101;
        default:action=3'b011;
        endcase
    end
endmodule
        

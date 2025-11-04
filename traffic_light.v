module traffic_light(input clk,input reset_n,output action);
    reg [2:0] action;
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
        red:next_State=yellow;
        green:next_State=yellow;
        yellow:next_State=green;
        default:next_State=red;
        endcase 
    end

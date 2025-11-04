module traffic_light(
    input clk,
    input reset_n,
    output reg [1:0] color,
    output reg [2:0] action
);
    
    parameter RED = 3'b000,
              Y1  = 3'b001,
              G1  = 3'b010,
              Y2  = 3'b011,
              G2  = 3'b100;

    reg [2:0] state, next_state;

 
    always @(posedge clk or negedge reset_n) begin
        if (!reset_n)
            state <= RED;
        else
            state <= next_state;
    end

    
    always @(*) begin
        case(state)
            RED: next_state = Y1;
            Y1:  next_state = G1;
            G1:  next_state = Y2;
            Y2:  next_state = G2;
            G2:  next_state = RED;
            default: next_state = RED;
        endcase
    end

    
    always @(*) begin
        case(state)
            RED:   begin color = 2'b00; action = 3'b011; end
            Y1, Y2:begin color = 2'b10; action = 3'b100; end
            G1, G2:begin color = 2'b01; action = 3'b101; end
            default:begin color = 2'b00; action = 3'b011; end
        endcase
    end
endmodule


        

module seq_det(clk,reset_n,xin,yout);
input clk,reset_n,xin;
output reg yout;
reg [2:0] state,next_state;
parameter s0=3'b000,
          s1=3'b001,
          s2=3'b010,
          s3=3'b011,
          s4=3'b100;
always@(posedge clk or negedge reset_n)begin
    if(!reset_n)
    state<=s0;
    else
    state<=next_state;
end
always@(xin or state)begin
    case(state)
    s0:next_state=(xin)?s1:s0;
    s1:next_state=(xin)?s1:s2;
    s2:next_state=(xin)?s3:s0;
    s3:next_state=(xin)?s4:s0;
    s4:next_state=(xin)?s1:s0;
    default:next_state=s0;
    endcase 
end
always@(xin or state) begin
    yout=0;
    case(state)
    s0:yout=0;
    s1:yout=0;
    s2:yout=0;
    s3:yout=0;
    s4:yout=(xin)?0:1;
    default:yout=0;
    endcase
end
endmodule
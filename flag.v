module flag(
    input clk,
    input reset_n,
    input secure,
    input risk,
    output Win,
    output Loss
);
parameter S0=3'b000,
          S1=3'b001,
          S2=3'b011,
          S3=3'b010,
          S4=3'b110;
reg [2:0] state, next_state;
always @(posedge clk or negedge reset_n) begin
    if (!reset_n)
        state <= S0;
    else
        state <= next_state;
end
always@(*) begin
    case(state)
    S0:begin 
        if(secure) next_state=S1;
        else if(risk) next_state=S4;
        else next_state=S0;
    end
    S1: begin
        if(secure) next_state=S1;
        else if(risk) next_state=S2;
        else next_state=S4;
    end
    S2: begin 
        if(secure || risk) next_state=S3;
        else next_state=S4;
    end 
    S3: begin
        if(secure) next_state=S0;
        else next_state=S4;
    end
    S4: begin 
        if(secure || risk) next_state=S4;
        else next_state=S0;
    end
    default: next_state=S0;
    endcase
end
assign Win=(state==S0&&secure==1'b1)?1'b1:1'b0;
assign Loss=(state==S4)?1'b1:1'b0;
endmodule
`timescale 1ns/1ps
module traffic_light_tb;

    // Declare testbench signals
    reg clk;
    reg reset_n;
    reg [1:0] color;
    wire [2:0] action;

    // Instantiate DUT (Device Under Test)
    traffic_light uut (
        .clk(clk),
        .reset_n(reset_n),
        .color(color),
        .action(action)
    );

    // Clock generation (10ns period)
    always #5 clk = ~clk;

    initial begin
        // Display header on terminal
        $display("Time\tclk\treset_n\tcolor\taction");
        $monitor("%0t\t%b\t%b\t%b\t%b", $time, clk, reset_n, color, action);

        // Initialize signals
        clk = 0;
        reset_n = 0;
        color = 2'b00;    // Start with red

        // Apply reset
        #10;
        reset_n = 1;

        // Simulate color sequence
        #10 color = 2'b00;   // Red
        #20 color = 2'b10;   // Yellow
        #20 color = 2'b01;   // Green
        #20 color = 2'b10;   // Yellow again
        #20 color = 2'b01;   // Green again
        #20 color = 2'b00;   // Back to Red

        // End simulation
        #50 $finish;
    end

endmodule

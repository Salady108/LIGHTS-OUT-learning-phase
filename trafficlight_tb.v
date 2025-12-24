`timescale 1ns/1ps
module traffic_light_tb;

    // Testbench signals
    reg clk;
    reg reset_n;
    wire [1:0] color;
    wire [2:0] action;

    // Instantiate the DUT (Device Under Test)
    traffic_light uut (
        .clk(clk),
        .reset_n(reset_n),
        .color(color),
        .action(action)
    );

    // Clock generation: 10 ns period (5 ns high, 5 ns low)
    always #5 clk = ~clk;

    initial begin
        // Display header
        $display("Time\tclk\treset_n\tcolor\taction");
        $monitor("%0t\t%b\t%b\t%b\t%b", $time, clk, reset_n, color, action);

        // Initialize
        clk = 0;
        reset_n = 0;

        // Hold reset low for a bit
        #12 reset_n = 1;   // release reset

        // Let the FSM run for a while
        #200 $finish;
    end

endmodule


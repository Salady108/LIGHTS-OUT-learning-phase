`timescale 1ns/1ps

module testbench;

    // PARAMETERS
    parameter N = 5; // length of the target sequence "10110"

    // SIGNALS
    reg clk, reset_n, xin;
    wire yout;

    // Instantiate DUT (Device Under Test)
    seq_det dut (
        .clk(clk),
        .reset_n(reset_n),
        .xin(xin),
        .yout(yout)
    );

    // Clock generation
    initial begin
        clk = 0;
        forever #5 clk = ~clk;   // 10 ns period
    end

    // Dumpfile setup for GTKWave / Vivado
    initial begin
        $dumpfile("seq_det.vcd");
        $dumpvars(0, testbench);
    end

    // Task: apply a 5-bit sequence (MSB first)
    task apply_sequence(input [N-1:0] seq, input integer idx);
        integer j;
        begin
            $display("\n=== Applying sequence %0d : %b ===", idx, seq);
            reset_n = 0;
            @(posedge clk);
            reset_n = 1;

            for (j = N-1; j >= 0; j = j - 1) begin
                xin = seq[j];
                @(posedge clk);
                $display("Time=%0t | Bit=%0d | xin=%b | yout=%b | state=%b", 
                         $time, (N-1-j), xin, yout, dut.state);
            end
            #10;
        end
    endtask

    // Generate block: apply all 32 sequences
    genvar i;
    generate
        for (i = 0; i < 32; i = i + 1) begin : ALL_SEQ
            initial begin
                #((i) * (N + 3) * 10); // delay between each sequence
                apply_sequence(i[4:0], i);
            end
        end
    endgenerate

    // Stop simulation after all sequences complete
    initial begin
        #(32 * (N + 3) * 10 + 100);
        $display("\n=== Simulation completed. Check seq_det.vcd for waveforms ===");
        $finish;
    end

endmodule

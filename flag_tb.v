`timescale 1ns/1ps

module flag_tb;

    // Testbench signals
    reg  clk;
    reg  reset_n;
    reg  secure;   // S
    reg  risk;     // R
    wire Win;
    wire Loss;

    // DUT instantiation
    flag dut (
        .clk    (clk),
        .reset_n(reset_n),
        .secure (secure),
        .risk   (risk),
        .Win    (Win),
        .Loss   (Loss)
    );

    // Clock generation: 10 ns period
    initial clk = 0;
    always #5 clk = ~clk;

    // Task to apply one move (R,S) for one clock cycle
    task move;
        input r;
        input s;
        begin
            risk   = r;
            secure = s;
            @(posedge clk);  // wait for state to update
            #5; // small delay after edge for stable outputs
            $display("T=%0t  R=%b S=%b  Win=%b Loss=%b", $time, risk, secure, Win, Loss);
        end
    endtask

    initial begin
        // Open a dump file for GTKWave or similar
        $dumpfile("flag_tb.vcd");
        $dumpvars(0, flag_tb);

        // Initial values
        secure  = 0;
        risk    = 0;
        reset_n = 0;

        // Reset
        @(posedge clk);
        reset_n = 1;  // release reset at a clock edge
        @(posedge clk);
        $display("=== Start of simulation ===");

        // ------------------------------
        // TEST 1: WIN SEQUENCE
        // S0 -> S1 -> S2 -> S3 -> S0 (Win)
        // ------------------------------
        $display("\n--- TEST 1: Valid WIN path ---");

        // At BASE (S0), Stall
        move(0,0); // stay S0

        // S0 -> S1 via Secure
        move(0,1); // secure

        // Hold in S1 with secure
        move(0,1); // still S1

        // S1 -> S2 via Risk
        move(1,0); // risk

        // S2 -> S3 via any move (choose secure)
        move(0,1);

        // S3 -> S0 via Secure (this should assert Win=1 for this cycle)
        move(0,1);

        // ------------------------------
        // TEST 2: Immediate LOSS from base by Risk
        // ------------------------------
        $display("\n--- TEST 2: Risk from BASE -> LOST ---");
        // back at S0 after previous test; do Risk
        move(1,0); // should go to S4 (Loss=1)

        // Stall to reset from LOST back to BASE
        move(0,0); // S4 -> S0

        // ------------------------------
        // TEST 3: Stall in ZONE_A -> LOST
        // ------------------------------
        $display("\n--- TEST 3: Stall in ZONE_A -> LOST ---");

        // S0 -> S1 via Secure
        move(0,1);

        // Stall in S1: should go to S4 (Loss=1)
        move(0,0);

        // Stall again to reset S4 -> S0
        move(0,0);

        // ------------------------------
        // TEST 4: Risk with FLAG (S3) -> LOST
        // ------------------------------
        $display("\n--- TEST 4: Risk in FLAGGED -> LOST ---");

        // S0 -> S1 (secure)
        move(0,1);
        // S1 -> S2 (risk)
        move(1,0);
        // S2 -> S3 (any, choose risk this time)
        move(1,0);
        // In S3 now, choose risk again => LOST
        move(1,0);

        // Finish
        $display("\n=== End of simulation ===");
        #20;
        $finish;
    end

endmodule

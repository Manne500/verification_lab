module lab_04 #(parameter PERIOD = 10) (
    output logic enable_1,
    output logic enable_2
);

    logic a, b, c;

    logic reset;

    logic clk;

    initial begin
        clk = 0;
    end

    always #(PERIOD/2) clk = ~clk;


    // Assertion to ensure either enable_1 or enable_2 is set @ clock edge
    assert_1 : assert property ( @(posedge clk) enable_1 || enable_2 );


    // Same assertion as above but extacting the property out
    property enables_checker;
        @(posedge clk) enable_1 || enable_2;
    endproperty

    assert_2 : assert property (enables_checker) else 
        $warning("enable_1 and enable_2 are both 0!");


    // Assert that if a is high and b is low, then c must be high in the same cycle; 
    // Otherwise we don't care about c
    assert_3 : assert property ( @(posedge clk) (a && !b) |-> c );


    // Assert that if a is high and b is low, then c must be high in the NEXT cycle
    assert_4 : assert property ( @(posedge clk) (a && !b) |=> c );  


    // Assert that if a is high and next cycle b is high, then c must be high in the cycle after
    // If a is low we don't care
    // If a is high and next cycle b is low, we don't care about c
    property a_b_c_checker;
        @(posedge clk) (a ##1 b) |=> c;
    endproperty

    assert_5 : assert property (a_b_c_checker);


    // Asset that if a and c are high this cycle, then 2 cycles later b must be high
    // But if a and c are high this cycle and reset happens we don't care about b anymore
    assert_6 : assert property ( @(posedge clk) disable iff (reset) (a && c) |-> ##2 b );


    initial begin
        reset = 0;

        a = 0;
        b = 0;
        c = 0;

        enable_1 = 1;
        enable_2 = 1;

        #30 enable_2 = 0;
        #20 enable_1 = 0;

        #10 
        enable_1 = 1;
        enable_2 = 1;

        #10
        a = 1;
        b = 0;
        c = 0;

        #10
        c = 1;

        #10
        c = 0;

        #10
        c = 1;

        #10
        b = 1;

        #10
        c = 0;

        #10
        c = 1;

        #10
        b = 0;

        #10 
        reset = 1;

        // Task 1

        // Task 2

        // Task 3

        // Task 4

    end

endmodule

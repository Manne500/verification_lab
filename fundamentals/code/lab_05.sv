module lab_05 #(parameter PERIOD = 10) (
    output logic enable_1,
    output logic enable_2
);


    logic reset;

    logic clk;

    logic [2:0] address;
    logic [7:0] data;


    initial clk = 0;

    always #(PERIOD/2) clk = ~clk;


    covergroup cg1 @(posedge clk);
        c1: coverpoint address;
        c2: coverpoint data;
    endgroup: cg1


    cg1 cover_inst = new();


    initial begin
        #10 address = 0;
        #10 address = 1;
        #10 address = 2;
        #10 address = 3;
        #10 address = 4;
        #10 address = 5;
        #10 address = 6;

        for (int i = 0; i < 254; i++) begin
            #10ns;
            data = i;
        end

        // Task 1

        // Task 2

        // Task 3

        // Task 4

    end

endmodule

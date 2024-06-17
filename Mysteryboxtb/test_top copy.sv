import tb_pkg::*;
//------------------------------------------------------------------------------------------------
// Section 0
// We will use the Randomizer to generate random constrained stimuli.
//------------------------------------------------------------------------------------------------
class RANDOMIZER;
    rand opcode op;
    rand logic[31:0] a;
    rand logic[31:0] b;
    constraint modulo_math_is_uncool {
        op != MAC; 
        op != ACC;}
endclass

module simple_alu_tb;

    //------------------------------------------------------------------------------
    // Section 1
    // TB internal signals
    //------------------------------------------------------------------------------    
    logic           tb_clock;
    logic           tb_reset_n;
    logic           tb_start_bit;
    logic [31:0]    tb_a;
    logic [31:0]    tb_b;
    logic [31:0]    tb_c;
    logic [7:0]     tb_max_count;
    int             errors;
    int             data_checked;
    opcode          tb_opcode;
    

    //------------------------------------------------------------------------------
    // Section 2
    // Initialize signals
    //------------------------------------------------------------------------------    
    initial begin
        tb_clock = 0;
        tb_reset_n = 0;
        tb_start_bit = 0;
        tb_a = 0;
        tb_b = 0;
        errors = 0;
        data_checked = 0;
        tb_max_count = 0;
    end

    //------------------------------------------------------------------------------
    // Section 3
    // Instantiation of mysterybox DUT (Design Under Test)(The thing we want to look at :)
    //------------------------------------------------------------------------------
    simple_alu DUT (
        .clock(tb_clock),
        .reset_n(tb_reset_n),
        .start(tb_start_bit),
        .a(tb_a),
        .b(tb_b),
        .c(tb_c),
        .mode_select(tb_opcode)
    );
    RANDOMIZER randy = new();
    //------------------------------------------------------------------------------
    // Section 4
    // Clock generator.
    //------------------------------------------------------------------------------
    initial begin
        forever begin
            tb_clock = #5ns ~tb_clock;
        end
    end

    //------------------------------------------------------------------------------
    // Section 5
    // Task to generate Reset simulus
    //------------------------------------------------------------------------------
    task automatic reset(int delay, int length);
        $display("%0t reset():            Starting delay=%0d length=%0d",$time(), delay, length);
        while (delay-- > 0) begin
            @(posedge tb_clock);
        end
        tb_reset_n <= 0;
        $display("%0t reset():            Reset activated",$time());
        // Min 1 clock that reset bit is active
        do begin
            @(posedge tb_clock);
        end while (--length > 0);
        tb_reset_n <= 1;
        $display("%0t reset():            Reset released",$time());
    endtask


    //------------------------------------------------------------------------------
    // Section 6
    // Task to generate start bit simulus
    //------------------------------------------------------------------------------
    task automatic start_bit(int delay, int length);
        $display("%0t start_bit():        Starting delay=%0d length=%0d",$time(), delay, length);
        // Min 1 clock synchronize start bit 
        do begin
            @(posedge tb_clock);
        end while (--delay > 0);
        tb_start_bit <= 1;
        $display("%0t start_bit():        Start bit activated ",$time());
        // Min 1 clock that start bit is active
        do begin
            @(posedge tb_clock);
        end while (--length > 0);
        tb_start_bit <= 0;
        $display("%0t start_bit():        Start bit released ",$time());
    endtask

    //------------------------------------------------------------------------------
    // Section 7
    // Task to simplify generation of signals.
    //------------------------------------------------------------------------------
    task automatic do_math(int a,int b,opcode code);
        $display("%0t do_math:   Opcode:%0s     First number=%0d Second Value=%0d",$time(),code.name(), a, b);
        @(posedge tb_clock);
        tb_start_bit <= 1;
        tb_a <= a;
        tb_b <= b;
        tb_opcode<= code;
        @(posedge tb_clock);
        tb_a <= '0;
        tb_b <= '0;
        tb_start_bit <= 0;
    endtask

    //------------------------------------------------------------------------------
    // Section 8
    // Functional coverage definitions. Expand on this!!!
    //------------------------------------------------------------------------------
    covergroup basic_fcov @(negedge tb_clock);

        data : coverpoint tb_c {
            wildcard bins even = { 32'b???????0 };
            wildcard bins odd  = { 32'b???????1 };
        }
        reset : coverpoint tb_reset_n {
            bins reset = { 0 };
            bins run=    { 1 };
        }
        
        state_cross : cross tb_opcode, reset;
    endgroup

    basic_fcov coverage;




    //------------------------------------------------------------------------------
    // Section 9
    // Test case task
    //Here we will start our meat and potatoes of the test.
    //------------------------------------------------------------------------------
    task test_case();
        // Task 2
        reset(.delay(0), .length(2));
             
        do_math(1,1,ADD);
        reset(.delay(10), .length(2));
        assert (tb_c == 0) 
            $display ("Output reset");
        else
            $error("Reset doesn't clear output!");
            
        

    endtask

    //------------------------------------------------------------------------------
    // Section 10
    // Start test case from time 0
    //------------------------------------------------------------------------------
    initial begin
        // Here we can call our tests. Start by initializing our coverage!
        coverage = new();
        if(randy.randomize())
            $display("Randomization done! :D");
        else 
            $error("Failed to randomize :(");
        $display("*****************************************************");
        $display("Starting Tests");
        $display("*****************************************************");
        repeat (2)
        test_case();
        $display("*****************************************************");
        $display("Tests Finished!");
        $display("*****************************************************");

        $stop;
    end

endmodule

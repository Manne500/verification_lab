module lab_02;

    class Packet;
        rand bit [3:0] src;
        rand bit [3:0] dest;
        rand bit [7:0] payload [];

        constraint payload_size {payload.size > 0; payload.size < 15;}
        // constraint payload_size_conflict {payload.size == 5;}
    endclass


    class SpecialPacket extends Packet;
        constraint c1 {src inside {[4'h9:4'hc]};}
        constraint c2 {dest inside {[0:8]}; }
        constraint payload_size {payload.size >= 15; payload.size < 20;}
        constraint c3 {foreach (payload[i]) { (payload[i]) > 'hbb;} }
    endclass


    class Bus;
        rand bit[15:0] addr;
        rand bit[31:0] data;

        constraint address_rule {addr[7:0] == 'h01;}
        constraint data_rule1 {data[15:0] == 'hffff;}
        constraint data_rule2 {data[31:16] > 'hafff;}
    endclass


    class CylicIntro;
        rand bit [2:0] d_normal;
        randc bit [2:0] d_cylic;
    endclass


    class Test1;
        task run;
            Packet packet;
            packet = new();

            repeat(8) begin
                packet.randomize;
                $displayh("%p", packet);
            end
            $display("");
        endtask;
    endclass: Test1


    class Test2;
        task run;
            SpecialPacket packet;
            packet = new();

            repeat(8) begin
                packet.randomize;
                $displayh("%p", packet);
            end
            $display("");
        endtask;
    endclass: Test2


    class Test3;
        task run;
            Bus bus;
            bus = new();

            repeat(8) begin
                bus.randomize;
                $displayh("%p", bus);
            end
            $display("");
        endtask;
    endclass: Test3


    class Test4;
        task run;
            Bus bus;
            bus = new();

            bus.data_rule1.constraint_mode(0);  // Turn constraint off
            bus.data_rule2.constraint_mode(0);  // Turn constraint off
            
            repeat(4) begin
                bus.randomize;
                $displayh("%p", bus);
            end

            bus.data_rule1.constraint_mode(1);  // Turn constraint on

            repeat(4) begin
                bus.randomize;
                $displayh("%p", bus);
            end
            $display("");
        endtask;
    endclass: Test4


    class Test5;
        task run;
            CylicIntro c;
            c = new();

            repeat(8) begin
                c.randomize;
                $displayh("%p", c);
            end
            $display("");
        endtask;
    endclass: Test5


    initial begin
        Test1 test1;
        Test2 test2;
        Test3 test3;
        Test4 test4;
        Test5 test5;

        test1 = new();
        test1.run();        

        test2 = new();
        test2.run();

        test3 = new();
        test3.run();

        test4 = new();
        test4.run();

        test5 = new();
        test5.run();

        // Task 1

        // Task 2

        // Task 3

        // Task 4

    end
    
endmodule

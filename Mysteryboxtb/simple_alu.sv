import tb_pkg::*;


module simple_alu(
    input  logic            clock,      
    input  logic            reset_n,
    input  logic            start,
    input  logic[31:0]      a,
    input  logic[31:0]      b,
    input  opcode           mode_select,       
    output logic[31:0]      c
    );

    //Internal Logic
    logic [31:0] a_reg,b_reg,internal_result,n_internal_result;


//<><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>
//Sequential Logic
//<><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>
    always_ff @(posedge clock or negedge reset_n) begin
        // Asynchronous reset
        if(~reset_n) begin
            internal_result<='0;
        end
        else begin
            internal_result <= n_internal_result;
            if (start) begin
                
                a_reg<=a;
                b_reg<=b;

            end
        end
 
    end

    //<><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>
    //Combinational logic
    //<><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>

    always_comb begin
    
        c <= internal_result;
        case (mode_select)

            //ADD
            ADD:  begin 
                n_internal_result <= a_reg+b_reg;
                
            end
            //SUB
            SUB:  begin 
                n_internal_result <= a_reg-b_reg;                      
            end
            //MUL
            MUL:  begin 
                n_internal_result <= a_reg*b_reg;
            end
            //DIV
            DIV:  begin 
                n_internal_result <= a_reg/b_reg;                        
            end
            //MOD
            MOD:  begin 
                n_internal_result <= a_reg%b_reg;
            end
            //ACC
            ACC:  begin 
                n_internal_result <=internal_result + a_reg;
            end                    
            MAC:  begin 
                n_internal_result <=internal_result + a_reg*b_reg;
            end
        endcase
    end



endmodule
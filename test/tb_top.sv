`timescale 1ns/1ps

module tb_top;

    logic l_Input_Clock_1;       
    logic l_Input_Clock_2;      
    logic l_Selected_Clock;
    logic resetn;
    logic [7:0] l_Output_Data;
    logic l_Data_Valid;
  
    top dut (
        .i_Input_Clock_1(l_Input_Clock_1),
        .i_Input_Clock_2(l_Input_Clock_2),
        .i_Selected_Clock(l_Selected_Clock),
        .resetn(resetn),
        .o_Output_Data(l_Output_Data),
        .o_Data_Valid(l_Data_Valid)
    );

    // Generate 150 MHz clock: period = 6.67 ns
    initial l_Input_Clock_1 = 0;
    always #3.335 l_Input_Clock_1 = ~l_Input_Clock_1;

    // Generate 200 MHz clock: period = 5 ns
    initial l_Input_Clock_2 = 0;
    always #2.5 l_Input_Clock_2 = ~l_Input_Clock_2;

    // Generate reset: start low, release after 50 ns
    initial begin
        resetn = 0;
        l_Selected_Clock = 0;
        #50;
        resetn = 1;
    end

    // Toggle l_Selected_Clock every 200 ns to switch clock sources
    initial begin
        #100;
        forever begin
            l_Selected_Clock = ~l_Selected_Clock;
            #200;
        end
    end
    
    initial begin
        $display("Time\tSelected_Clock\tOutput_Data\tData_Valid");
        $monitor("%0t\t%b\t\t%0h\t\t%b", $time, l_Selected_Clock, l_Output_Data, l_Data_Valid);
    end

    initial begin
        #1000;
        $finish;
    end

endmodule

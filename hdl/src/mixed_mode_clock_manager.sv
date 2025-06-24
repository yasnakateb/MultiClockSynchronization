module mixed_mode_clock_manager (
    input logic i_Input_Clock_1,
    input logic i_Input_Clock_2,
    input logic resetn,
    output logic o_Output_Clock_1,
    output logic o_Output_Clock_2,
    output logic o_Output_Clock_3
    );

    assign o_Output_Clock_1 = i_Input_Clock_1;
    assign o_Output_Clock_2 = i_Input_Clock_2;
    assign o_Output_Clock_3 = i_Input_Clock_1; 

endmodule

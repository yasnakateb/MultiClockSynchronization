module top (
    input logic i_Input_Clock_1,     
    input logic i_Input_Clock_2,     
    input logic i_Selected_Clock,  
    input logic resetn,      
    output logic [7:0] o_Output_Data,
    output logic o_Data_Valid
    );

    logic l_Clock_150_MHz;
    logic l_Clock_200_MHz;
    logic l_Clock_Selected;
    logic l_Clock_Slow; 

    mixed_mode_clock_manager Mmcm_Inst (
        .i_Input_Clock_1(i_Input_Clock_1),
        .i_Input_Clock_2(i_Input_Clock_2),
        .resetn(resetn),
        .o_Output_Clock_1(l_Clock_150_MHz),
        .o_Output_Clock_2(l_Clock_200_MHz),
        .o_Output_Clock_3(l_Clock_Slow)
    );
    
    assign l_Clock_Selected = (i_Selected_Clock) ? l_Clock_200_MHz : l_Clock_150_MHz;
   
    logic [7:0] l_Data_Fast;
    logic l_Data_Fast_Valid;

    data_producer Producer_Inst (
        .clk(l_Clock_Selected),
        .resetn(resetn),
        .o_Output_Data(l_Data_Fast),
        .o_Data_Valid(l_Data_Fast_Valid)
    );
   
    logic [7:0] l_Data_Slow;
    logic l_Data_Slow_Valid;
    logic l_Fifo_Read_Enable;
    logic l_Fifo_Empty;

    cdc_fifo #(.DATA_WIDTH(8), .DEPTH(16)) Cdc_Fifo_Inst (
        .i_Write_Clock(l_Clock_Selected),
        .i_Read_Clock(l_Clock_Slow),
        .resetn(resetn),
        .i_Input_Data(l_Data_Fast),
        .i_Write_Enable(l_Data_Fast_Valid),
        .o_Output_Data(l_Data_Slow),
        .i_Read_Enable(l_Fifo_Read_Enable),
        .o_Empty(l_Fifo_Empty),
        .o_Full()
    );

    always_ff @(posedge l_Clock_Slow or negedge resetn) begin
        if (!resetn)
            l_Fifo_Read_Enable <= 1'b0;
        else
            l_Fifo_Read_Enable <= !l_Fifo_Empty;
    end
    
    assign l_Data_Slow_Valid = !l_Fifo_Empty;
   
    data_consumer Consumer_Inst (
        .clk(l_Clock_Slow),
        .resetn(resetn),
        .i_Input_Data(l_Data_Slow),
        .i_Data_Valid(l_Data_Slow_Valid),
        .o_Output_Data(o_Output_Data),
        .o_Data_Valid(o_Data_Valid)
    );

endmodule
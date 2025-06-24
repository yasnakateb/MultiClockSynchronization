module cdc_fifo #(
        parameter DATA_WIDTH = 8,
        parameter DEPTH = 16,
        parameter ADDR_WIDTH = $clog2(DEPTH)
    ) (
        input logic i_Write_Clock,
        input logic i_Read_Clock,
        input logic resetn,
        input logic [DATA_WIDTH-1:0] i_Input_Data,
        input logic i_Write_Enable,
        output logic [DATA_WIDTH-1:0] o_Output_Data,
        input  logic i_Read_Enable,
        output logic o_Empty,
        output logic o_Full
    );

    logic [ADDR_WIDTH-1:0] l_Write_Pointer;
    logic [ADDR_WIDTH-1:0] l_Read_Pointer;

    logic [DATA_WIDTH-1:0] mem [0:DEPTH-1];

    always_ff @(posedge i_Write_Clock or negedge resetn) begin
        if (!resetn) begin
            l_Write_Pointer <= 0;
        end else if (i_Write_Enable && !o_Full) begin
            mem[l_Write_Pointer] <= i_Input_Data;
            l_Write_Pointer <= l_Write_Pointer + 1;
        end
    end
    
    always_ff @(posedge i_Read_Clock or negedge resetn) begin
        if (!resetn) begin
            l_Read_Pointer <= 0;
        end else if (i_Read_Enable && !o_Empty) begin
            l_Read_Pointer <= l_Read_Pointer + 1;
        end
    end
    
    assign o_Output_Data = mem[l_Read_Pointer];

    assign o_Empty = (l_Write_Pointer == l_Read_Pointer);
    assign o_Full = ((l_Write_Pointer + 1) == l_Read_Pointer);

endmodule
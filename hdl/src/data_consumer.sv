module data_consumer (
    input logic clk,
    input logic resetn,
    input logic [7:0] i_Input_Data,
    input logic i_Data_Valid,
    output logic [7:0] o_Output_Data,
    output logic o_Data_Valid
    );

    always_ff @(posedge clk or negedge resetn) begin
        if (!resetn) begin
            o_Output_Data  <= 0;
            o_Data_Valid <= 0;
        end else if (i_Data_Valid) begin
            o_Output_Data  <= i_Input_Data;
            o_Data_Valid <= 1;
        end else begin
            o_Data_Valid <= 0;
        end
    end

endmodule

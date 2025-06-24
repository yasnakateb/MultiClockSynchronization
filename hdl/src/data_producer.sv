module data_producer (
    input logic clk,
    input logic resetn,
    output logic [7:0] o_Output_Data,
    output logic o_Data_Valid
    );

    logic [7:0] r_Counter;

    always_ff @(posedge clk or negedge resetn) begin
        if (!resetn) begin
            r_Counter   <= 0;
            o_Data_Valid <= 0;
        end else begin
            r_Counter <= r_Counter + 1;
            o_Output_Data <= r_Counter;
            o_Data_Valid <= 1;
        end
    end

endmodule
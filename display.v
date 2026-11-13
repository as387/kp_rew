module display (
    input wire clk_1MHz,
    input wire reset,
    input wire [11:0] distance,
    input wire [3:0] err_num,
    output wire [11:0] finish_signal
);

    reg [11:0] complete;

    always @(posedge clk_1MHz or posedge reset) begin
        if (reset) begin
            complete <= 12'd0;
        end else begin
            if (err_num != 4'b0) begin
                complete <= {4'b1110, 4'b0000, err_num};
            end else begin
                complete <= distance;
            end
        end
    end

    assign finish_signal = complete;

endmodule
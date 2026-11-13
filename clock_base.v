module clock_base #(
    parameter clk_div = 24
) (
    input wire clk_50Meg,
    input wire reset,
    output wire clk_counter    // выход 1 МГц
);
    
    reg [5:0] counter1;         // счетчик 1 МГц
    reg out;                   // регистр для выхода 1 МГц

    always @(posedge clk_50Meg or posedge reset) begin
        if (reset) begin
            counter1 <= 6'd0;
            out      <= 1'd0;
        end else begin
            if (counter1 == clk_div) begin
                counter1 <= 6'd0;
                out      <= ~out;
            end else begin
                counter1 <= counter1 + 6'd1;
            end
        end
    end

    assign clk_counter = out;

endmodule
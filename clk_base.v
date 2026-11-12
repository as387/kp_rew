module clock_base #(
    parameter clk_div1 = 24,
    parameter clk_div2 = 1499999
) (
    input wire clk_50Meg,
    input wire reset,
    output wire clk_counter,
    output wire clk_echo
);
    
    reg [5:0] counter1;
    reg [20:0] counter2;
    reg out1;
    reg out2;

    always @(posedge clk_50Meg or posedge reset) begin

        if (reset) begin
            counter1 <= 6'd0;
            out1     <= 1'd0;
            counter2 <= 21'd0;
            out2     <= 1'd0;
        end else begin

            if (counter1 == clk_div1) begin
                counter1 <= 6'd0;
                out1 <= ~out1;
            end else begin
                counter1 <= counter1 + 6'd1;
            end

            if (counter2 == clk_div2) begin
                counter2 <= 21'd0;
                out2     <= ~out2;
            end else begin
                counter2 <= counter2 + 21'd1;
            end
        end
    end

    assign clk_counter = out1;
    assign clk_echo = out2;

endmodule
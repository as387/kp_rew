module TopFile (
    input wire clk_50Meg,       // тактовый сигнал
//    input wire start,         // сигнал запуска
    input wire reset,           // сигнал сброса
    output wire [15:0] data,    // выходные данные
    output wire trig,           // выходной сигнал триггера
    input wire echo             // входной сигнал эхо  
);

    wire clk_1MHz;
    wire clk_16Hz;

    clock_base clk_base_module (
        .clk_50Meg(clk_50Meg),
        .reset(reset),
        .clk_counter(clk_1MHz),
        .clk_echo(clk_16Hz)
    );

    assign trig = clk_1MHz;
    assign data = 16'd0;

endmodule
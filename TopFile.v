module TopFile (
    input wire clk_50Meg,     // тактовый сигнал
    input wire start,         // сигнал запуска
    input wire reset,         // сигнал сброса
    output wire [15:0] data,  // выходные данные
    output wire trig,         // выходной сигнал триггера
    input wire echo           // входной сигнал эхо  
);

endmodule


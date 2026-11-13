module distance #(
    parameter multiplier = 18079,             // коэффициент пересчета в сантиметры
    parameter shift = 20,                   // коэффициент сдвига 

    parameter max_threshold = 400,           // максимальное значение измерения в сантиметрах
    parameter min_threshold = 3              // минимальное значение измерения в сантиметрах
) (
    input wire clk_50Meg,
    input wire reset,
    input wire [14:0] actual_measurement,   // входные данные от echo_receiver
    output wire [11:0] distance,             // выходные данные в сантиметрах
    output wire err
);
    reg [29:0] distance_1;  // умножение на коэффициент пересчета в сантиметры
    reg [9:0] distance_2;  // сдвиг на коэффициент сдвига
    
    integer i;

    reg [11:0] BCD_distance;
    reg [9:0] bin;

    always @(posedge clk_50Meg or posedge reset) begin
        if (reset) begin 
            distance_1 <= 30'd0;        // 15 входных бит + 15 (18079 < 2^^15)
            distance_2 <= 10'd0;        // 30 - 20 (сдвиг на коэффициент сдвига)
        end else begin
            distance_1 <= actual_measurement * multiplier;   // умножение на коэффициент пересчета в сантиметры
            distance_2 <= distance_1 >> shift;               // сдвиг на коэффициент сдвига - расстояние в см
        end
    end

    always @(*) begin
        BCD_distance = 12'd0;
        bin = distance_2;
        
        for (i = 0; i < 10; i = i + 1) begin
            if (BCD_distance[3:0] >= 5) begin
                BCD_distance[3:0] = BCD_distance[3:0] + 3;
            end
            if (BCD_distance[7:4] >= 5) begin
                BCD_distance[7:4] = BCD_distance[7:4] + 3;
            end
            if (BCD_distance[11:8] >= 5) begin
                BCD_distance[11:8] = BCD_distance[11:8] + 3;
            end

            BCD_distance = {BCD_distance[10:0], bin[9]};
            bin = {bin[8:0], 1'b0};
        end
    end

    assign err = (distance_2 > max_threshold) || (distance_2 < min_threshold);
    assign distance = BCD_distance;

endmodule
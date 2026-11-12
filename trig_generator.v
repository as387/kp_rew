module trig_generator #(
    parameter trig_time = 9,
    parameter delay_time = 59
) ( 
    input wire clk_1MHz,
    input wire reset,
    output wire trig
);
    reg [5:0] delay_counter;
    reg trig_value;

    always @(posedge clk_1MHz or posedge reset) begin
        if (reset) begin                                 // сброс
            delay_counter <= 6'd0;
            trig_value <= 1'b0;

        end else begin                                   // если такт >= 60
            if (delay_counter >= delay_time) begin
                delay_counter <= 6'd0;

            end else begin                               // если так < 60
                delay_counter <= delay_counter + 6'd1;   // счетчик ++ 

                if (delay_counter <= trig_time) 
                begin                                    // если такт <= 10 
                    trig_value <= 1'b1;                  // триггер <= 1 
                end 
                else begin                               // если такт > 10
                    trig_value <= 1'b0;                  // триггер <= 0
                end
            end
        end
    end
    
    assign trig = trig_value;

endmodule
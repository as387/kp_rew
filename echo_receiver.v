module echo_receiver (
    input wire clk_1MHz,
    input wire reset,
    input wire echo_signal,
    output wire [14:0] actual_measurement
);

    reg meta_trig;
    reg sinc_trig;

    always @(posedge clk_1MHz or posedge reset) begin
        if (reset) begin
            meta_trig <= 1'b0;
            sinc_trig <= 1'b0;
        end else begin 
            meta_trig <= echo_signal;
            sinc_trig <= meta_trig;
        end
    end

    reg old;
    reg [14:0] measurement;
    reg [14:0] actual;

    always @(posedge clk_1MHz or posedge reset) begin
        if (reset) begin
            old   <= 1'b0;
            measurement <= 15'b0;
            actual <= 15'b0;
        end else begin 
            old <= sinc_trig;
            if (sinc_trig == 1'b1) begin 
                if (measurement < 15'd32767)    // переполнение счетчика
                                                // Добавить верификацию на таймаут счетчика 
                    measurement <= measurement + 15'b1;
            end else if (old == 1'b1) begin
                actual <= measurement;
                measurement <= 15'b0;
            end
        end
    end 

    assign actual_measurement = actual;

endmodule
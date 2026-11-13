module echo_receiver (
    input wire clk_1MHz,
    input wire reset,
    input wire echo_signal,
    input wire trig,
    output wire [14:0] actual_measurement,
    output reg [3:0] err_num
);

    reg meta_trig;
    reg sinc_trig;

    reg trig_old;
    always @(posedge clk_1MHz or posedge reset)
        if (reset) trig_old <= 1'b0;
        else       trig_old <= trig;

    wire trig_rise = trig & ~trig_old;          // детектор фронта trig

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
    reg [15:0] silence_measurement;
    reg [14:0] actual;

    always @(posedge clk_1MHz or posedge reset) begin
        if (reset) begin
            old   <= 1'b0;
            measurement <= 15'b0;
            actual <= 15'b0;
            silence_measurement <= 16'd0;
            err_num <= 4'b0;
        end else begin
            old <= sinc_trig;
            if (trig_rise) begin
                measurement <= 15'b0;
                silence_measurement <= 16'd0;
                err_num <= 4'b0;
            end else if (sinc_trig == 1'b1) begin
                silence_measurement <= 16'd0;
                if (measurement < 15'd32767) begin
                    measurement <= measurement + 15'b1;
                end else err_num <= 4'd2;

            end else if (old == 1'b1) begin
                silence_measurement <= 16'd0;
                actual <= measurement;
                measurement <= 15'b0;
            end else begin
                if (silence_measurement < 16'd60000)
                    silence_measurement <= silence_measurement + 16'd1;
                else 
                    err_num <= 4'd1;
            end
        end
    end

    assign actual_measurement = actual;

endmodule
module TopFile (
    input  wire clk_50Meg,
    input  wire reset,
    output wire [15:0] data,
    output wire trig,
    input  wire echo
);
    wire clk_1MHz;
    wire [14:0] actual_measurement;
    wire [11:0] distance_bcd;
    wire [3:0]  err_echo, err_dist;
    wire [3:0]  err_num = (err_echo != 4'd0) ? err_echo : err_dist;
    wire [11:0] finish_signal;

    clock_base clk_base_module (
        .clk_50Meg(clk_50Meg),
        .reset(reset),
        .clk_counter(clk_1MHz)
    );

    trig_generator trig_gen (
        .clk_1MHz(clk_1MHz),
        .reset(reset),
        .trig(trig)
    );

    echo_receiver echo_rx (
        .clk_1MHz(clk_1MHz),
        .reset(reset),
        .trig(trig),
        .echo_signal(echo),
        .actual_measurement(actual_measurement),
        .err_num(err_echo)
    );

    distance dist (
        .clk_1MHz(clk_1MHz),
        .reset(reset),
        .actual_measurement(actual_measurement),
        .distance(distance_bcd),
        .err_num(err_dist)
    );

    display disp (
        .clk_1MHz(clk_1MHz),
        .reset(reset),
        .distance(distance_bcd),
        .err_num(err_num),
        .finish_signal(finish_signal)
    );

    assign data = {4'b0, finish_signal};

endmodule
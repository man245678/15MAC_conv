module MAC
#(
    parameter DATA_BW = 8
)(
    input CLK,
    input RSTN,
    input EN,

    input signed [DATA_BW-1:0] IFMAP_DATA_IN1,
    input signed [DATA_BW-1:0] IFMAP_DATA_IN2,
    input signed [DATA_BW-1:0] IFMAP_DATA_IN3,
    input signed [DATA_BW-1:0] IFMAP_DATA_IN4,
    input signed [DATA_BW-1:0] IFMAP_DATA_IN5,
    input signed [DATA_BW-1:0] IFMAP_DATA_IN6,
    input signed [DATA_BW-1:0] IFMAP_DATA_IN7,
    input signed [DATA_BW-1:0] IFMAP_DATA_IN8,
    input signed [DATA_BW-1:0] IFMAP_DATA_IN9,
    input signed [DATA_BW-1:0] IFMAP_DATA_IN10,
    input signed [DATA_BW-1:0] IFMAP_DATA_IN11,
    input signed [DATA_BW-1:0] IFMAP_DATA_IN12,
    input signed [DATA_BW-1:0] IFMAP_DATA_IN13,
    input signed [DATA_BW-1:0] IFMAP_DATA_IN14,
    input signed [DATA_BW-1:0] IFMAP_DATA_IN15,

    input signed [DATA_BW-1:0] FILTER_DATA_IN1,
    input signed [DATA_BW-1:0] FILTER_DATA_IN2,
    input signed [DATA_BW-1:0] FILTER_DATA_IN3,
    input signed [DATA_BW-1:0] FILTER_DATA_IN4,
    input signed [DATA_BW-1:0] FILTER_DATA_IN5,
    input signed [DATA_BW-1:0] FILTER_DATA_IN6,
    input signed [DATA_BW-1:0] FILTER_DATA_IN7,
    input signed [DATA_BW-1:0] FILTER_DATA_IN8,
    input signed [DATA_BW-1:0] FILTER_DATA_IN9,
    input signed [DATA_BW-1:0] FILTER_DATA_IN10,
    input signed [DATA_BW-1:0] FILTER_DATA_IN11,
    input signed [DATA_BW-1:0] FILTER_DATA_IN12,
    input signed [DATA_BW-1:0] FILTER_DATA_IN13,
    input signed [DATA_BW-1:0] FILTER_DATA_IN14,
    input signed [DATA_BW-1:0] FILTER_DATA_IN15,

    output signed [2*DATA_BW-1:0] MUL_DATA_OUT
);

wire signed [2*DATA_BW-1:0] mul1  = IFMAP_DATA_IN1  * FILTER_DATA_IN1;
wire signed [2*DATA_BW-1:0] mul2  = IFMAP_DATA_IN2  * FILTER_DATA_IN2;
wire signed [2*DATA_BW-1:0] mul3  = IFMAP_DATA_IN3  * FILTER_DATA_IN3;
wire signed [2*DATA_BW-1:0] mul4  = IFMAP_DATA_IN4  * FILTER_DATA_IN4;
wire signed [2*DATA_BW-1:0] mul5  = IFMAP_DATA_IN5  * FILTER_DATA_IN5;
wire signed [2*DATA_BW-1:0] mul6  = IFMAP_DATA_IN6  * FILTER_DATA_IN6;
wire signed [2*DATA_BW-1:0] mul7  = IFMAP_DATA_IN7  * FILTER_DATA_IN7;
wire signed [2*DATA_BW-1:0] mul8  = IFMAP_DATA_IN8  * FILTER_DATA_IN8;
wire signed [2*DATA_BW-1:0] mul9  = IFMAP_DATA_IN9  * FILTER_DATA_IN9;
wire signed [2*DATA_BW-1:0] mul10 = IFMAP_DATA_IN10 * FILTER_DATA_IN10;
wire signed [2*DATA_BW-1:0] mul11 = IFMAP_DATA_IN11 * FILTER_DATA_IN11;
wire signed [2*DATA_BW-1:0] mul12 = IFMAP_DATA_IN12 * FILTER_DATA_IN12;
wire signed [2*DATA_BW-1:0] mul13 = IFMAP_DATA_IN13 * FILTER_DATA_IN13;
wire signed [2*DATA_BW-1:0] mul14 = IFMAP_DATA_IN14 * FILTER_DATA_IN14;
wire signed [2*DATA_BW-1:0] mul15 = IFMAP_DATA_IN15 * FILTER_DATA_IN15;

assign MUL_DATA_OUT = EN ? (mul1 + mul2 + mul3 + mul4 + mul5 +
                            mul6 + mul7 + mul8 + mul9 + mul10 +
                            mul11 + mul12 + mul13 + mul14 + mul15) : 0;

endmodule

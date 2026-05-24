module Convolver
#(
    parameter ADDR_WIDTH  = 15,
    parameter BITWIDTH    = 8
)(
    input wire clk,
    input wire resetn,
    input wire signed [BITWIDTH-1:0] IMAGE_RAM_DIN,
    input wire signed [BITWIDTH-1:0] FILTER_RAM_DIN,
    input wire signed [2*BITWIDTH-1:0] FEATURE_RAM_DIN,
    input wire IMAGE_RAM_DATA_VAL,
    input wire FILTER_RAM_DATA_VAL,
    input wire FEATURE_RAM_DATA_VAL,

    output wire IMAGE_RAM_EN,
    output wire FILTER_RAM_EN,
    output wire FEATURE_RAM_EN,
    output wire FEATURE_RAM_WEN,

    output wire [ADDR_WIDTH-1:0] IMAGE_RAM_ADDRESS,
    output wire [ADDR_WIDTH-1:0] FILTER_RAM_ADDRESS,
    output wire [ADDR_WIDTH-1:0] FEATURE_RAM_ADDRESS,

    output wire signed [2*BITWIDTH-1:0] FEATURE_RAM_DOUT,
    output wire eoc
);

    localparam IMAGE_WIDTH   = 98;
    localparam FEATURE_WIDTH = 32;
    localparam KERNEL_WIDTH  = 5;
    localparam CHANNELS      = 3;

    wire image_read_fin;
    wire filter_read_fin;
    wire mac_acc_clear;
    wire calc_start;
    wire kernel_row_en;
    wire feature_index_en;
    wire kernel_row_fin;
    wire feature_index_fin;

    reg signed [BITWIDTH-1:0] IMAGE_RAM [0:CHANNELS*IMAGE_WIDTH*IMAGE_WIDTH-1];
    reg signed [BITWIDTH-1:0] FILTER_RAM [0:CHANNELS*KERNEL_WIDTH*KERNEL_WIDTH-1];

    reg [2:0] kernel_row_cnt;
    reg [4:0] feature_x_cnt;
    reg [4:0] feature_y_cnt;
    reg signed [2*BITWIDTH-1:0] acc_result;

    wire signed [2*BITWIDTH-1:0] mac_data_out;

    FSM fsm (
        .CLK(clk),
        .RSTN(resetn),
        .IMAGE_READ_FIN(image_read_fin),
        .FILTER_READ_FIN(filter_read_fin),
        .KERNEL_ROW_FIN(kernel_row_fin),
        .FEATURE_INDEX_FIN(feature_index_fin),
        .MAC_ACC_CLEAR(mac_acc_clear),
        .CALC_START(calc_start),
        .KERNEL_ROW_EN(kernel_row_en),
        .FEATURE_INDEX_EN(feature_index_en),
        .IMAGE_RAM_EN(IMAGE_RAM_EN),
        .FILTER_RAM_EN(FILTER_RAM_EN),
        .FEATURE_RAM_EN(FEATURE_RAM_EN),
        .FEATURE_RAM_WEN(FEATURE_RAM_WEN),
        .EOC(eoc)
    );

    cntImage u_cntImage (
        .resetn(resetn),
        .enable(IMAGE_RAM_EN),
        .carryIN(IMAGE_RAM_DATA_VAL),
        .carryOUT(image_read_fin),
        .countVal(IMAGE_RAM_ADDRESS)
    );

    cntFilter u_cntFilter (
        .resetn(resetn),
        .enable(FILTER_RAM_EN),
        .carryIN(FILTER_RAM_DATA_VAL),
        .carryOUT(filter_read_fin),
        .countVal(FILTER_RAM_ADDRESS)
    );

    always @ (posedge clk) begin
        if(IMAGE_RAM_DATA_VAL)
            IMAGE_RAM[IMAGE_RAM_ADDRESS] <= IMAGE_RAM_DIN;

        if(FILTER_RAM_DATA_VAL)
            FILTER_RAM[FILTER_RAM_ADDRESS] <= FILTER_RAM_DIN;
    end

    wire [ADDR_WIDTH-1:0] addr_image_base =
        feature_x_cnt * CHANNELS + feature_y_cnt * CHANNELS * IMAGE_WIDTH;

    wire [ADDR_WIDTH-1:0] image_row_offset = kernel_row_cnt * IMAGE_WIDTH;
    wire [ADDR_WIDTH-1:0] filter_row_offset = kernel_row_cnt * KERNEL_WIDTH;

    wire [ADDR_WIDTH-1:0] image_offset1  = addr_image_base + image_row_offset + 0;
    wire [ADDR_WIDTH-1:0] image_offset2  = addr_image_base + image_row_offset + 1;
    wire [ADDR_WIDTH-1:0] image_offset3  = addr_image_base + image_row_offset + 2;
    wire [ADDR_WIDTH-1:0] image_offset4  = addr_image_base + image_row_offset + 3;
    wire [ADDR_WIDTH-1:0] image_offset5  = addr_image_base + image_row_offset + 4;
    wire [ADDR_WIDTH-1:0] image_offset6  = addr_image_base + image_row_offset + IMAGE_WIDTH*IMAGE_WIDTH + 0;
    wire [ADDR_WIDTH-1:0] image_offset7  = addr_image_base + image_row_offset + IMAGE_WIDTH*IMAGE_WIDTH + 1;
    wire [ADDR_WIDTH-1:0] image_offset8  = addr_image_base + image_row_offset + IMAGE_WIDTH*IMAGE_WIDTH + 2;
    wire [ADDR_WIDTH-1:0] image_offset9  = addr_image_base + image_row_offset + IMAGE_WIDTH*IMAGE_WIDTH + 3;
    wire [ADDR_WIDTH-1:0] image_offset10 = addr_image_base + image_row_offset + IMAGE_WIDTH*IMAGE_WIDTH + 4;
    wire [ADDR_WIDTH-1:0] image_offset11 = addr_image_base + image_row_offset + IMAGE_WIDTH*IMAGE_WIDTH*2 + 0;
    wire [ADDR_WIDTH-1:0] image_offset12 = addr_image_base + image_row_offset + IMAGE_WIDTH*IMAGE_WIDTH*2 + 1;
    wire [ADDR_WIDTH-1:0] image_offset13 = addr_image_base + image_row_offset + IMAGE_WIDTH*IMAGE_WIDTH*2 + 2;
    wire [ADDR_WIDTH-1:0] image_offset14 = addr_image_base + image_row_offset + IMAGE_WIDTH*IMAGE_WIDTH*2 + 3;
    wire [ADDR_WIDTH-1:0] image_offset15 = addr_image_base + image_row_offset + IMAGE_WIDTH*IMAGE_WIDTH*2 + 4;

    wire [ADDR_WIDTH-1:0] filter_offset1  = filter_row_offset + 0;
    wire [ADDR_WIDTH-1:0] filter_offset2  = filter_row_offset + 1;
    wire [ADDR_WIDTH-1:0] filter_offset3  = filter_row_offset + 2;
    wire [ADDR_WIDTH-1:0] filter_offset4  = filter_row_offset + 3;
    wire [ADDR_WIDTH-1:0] filter_offset5  = filter_row_offset + 4;
    wire [ADDR_WIDTH-1:0] filter_offset6  = 25 + filter_row_offset + 0;
    wire [ADDR_WIDTH-1:0] filter_offset7  = 25 + filter_row_offset + 1;
    wire [ADDR_WIDTH-1:0] filter_offset8  = 25 + filter_row_offset + 2;
    wire [ADDR_WIDTH-1:0] filter_offset9  = 25 + filter_row_offset + 3;
    wire [ADDR_WIDTH-1:0] filter_offset10 = 25 + filter_row_offset + 4;
    wire [ADDR_WIDTH-1:0] filter_offset11 = 50 + filter_row_offset + 0;
    wire [ADDR_WIDTH-1:0] filter_offset12 = 50 + filter_row_offset + 1;
    wire [ADDR_WIDTH-1:0] filter_offset13 = 50 + filter_row_offset + 2;
    wire [ADDR_WIDTH-1:0] filter_offset14 = 50 + filter_row_offset + 3;
    wire [ADDR_WIDTH-1:0] filter_offset15 = 50 + filter_row_offset + 4;

    MAC #(
        .DATA_BW(BITWIDTH)
    ) u_MAC (
        .CLK(clk),
        .RSTN(resetn),
        .EN(calc_start),
        .IFMAP_DATA_IN1(IMAGE_RAM[image_offset1]),
        .IFMAP_DATA_IN2(IMAGE_RAM[image_offset2]),
        .IFMAP_DATA_IN3(IMAGE_RAM[image_offset3]),
        .IFMAP_DATA_IN4(IMAGE_RAM[image_offset4]),
        .IFMAP_DATA_IN5(IMAGE_RAM[image_offset5]),
        .IFMAP_DATA_IN6(IMAGE_RAM[image_offset6]),
        .IFMAP_DATA_IN7(IMAGE_RAM[image_offset7]),
        .IFMAP_DATA_IN8(IMAGE_RAM[image_offset8]),
        .IFMAP_DATA_IN9(IMAGE_RAM[image_offset9]),
        .IFMAP_DATA_IN10(IMAGE_RAM[image_offset10]),
        .IFMAP_DATA_IN11(IMAGE_RAM[image_offset11]),
        .IFMAP_DATA_IN12(IMAGE_RAM[image_offset12]),
        .IFMAP_DATA_IN13(IMAGE_RAM[image_offset13]),
        .IFMAP_DATA_IN14(IMAGE_RAM[image_offset14]),
        .IFMAP_DATA_IN15(IMAGE_RAM[image_offset15]),
        .FILTER_DATA_IN1(FILTER_RAM[filter_offset1]),
        .FILTER_DATA_IN2(FILTER_RAM[filter_offset2]),
        .FILTER_DATA_IN3(FILTER_RAM[filter_offset3]),
        .FILTER_DATA_IN4(FILTER_RAM[filter_offset4]),
        .FILTER_DATA_IN5(FILTER_RAM[filter_offset5]),
        .FILTER_DATA_IN6(FILTER_RAM[filter_offset6]),
        .FILTER_DATA_IN7(FILTER_RAM[filter_offset7]),
        .FILTER_DATA_IN8(FILTER_RAM[filter_offset8]),
        .FILTER_DATA_IN9(FILTER_RAM[filter_offset9]),
        .FILTER_DATA_IN10(FILTER_RAM[filter_offset10]),
        .FILTER_DATA_IN11(FILTER_RAM[filter_offset11]),
        .FILTER_DATA_IN12(FILTER_RAM[filter_offset12]),
        .FILTER_DATA_IN13(FILTER_RAM[filter_offset13]),
        .FILTER_DATA_IN14(FILTER_RAM[filter_offset14]),
        .FILTER_DATA_IN15(FILTER_RAM[filter_offset15]),
        .MUL_DATA_OUT(mac_data_out)
    );

    assign kernel_row_fin = (kernel_row_cnt == 4) && calc_start;
    assign feature_index_fin = (feature_x_cnt == FEATURE_WIDTH-1) &&
                               (feature_y_cnt == FEATURE_WIDTH-1);
    assign FEATURE_RAM_ADDRESS = feature_x_cnt + feature_y_cnt * FEATURE_WIDTH;
    assign FEATURE_RAM_DOUT = acc_result;

    always @ (posedge clk or negedge resetn) begin
        if(!resetn) begin
            kernel_row_cnt <= 0;
            feature_x_cnt <= 0;
            feature_y_cnt <= 0;
            acc_result <= 0;
        end
        else begin
            if(mac_acc_clear) begin
                kernel_row_cnt <= 0;
                acc_result <= 0;
            end
            else if(kernel_row_en) begin
                acc_result <= acc_result + mac_data_out;

                if(kernel_row_cnt == 4)
                    kernel_row_cnt <= 0;
                else
                    kernel_row_cnt <= kernel_row_cnt + 1;
            end

            if(feature_index_en && !feature_index_fin) begin
                if(feature_x_cnt == FEATURE_WIDTH-1) begin
                    feature_x_cnt <= 0;
                    feature_y_cnt <= feature_y_cnt + 1;
                end
                else begin
                    feature_x_cnt <= feature_x_cnt + 1;
                end
            end
        end
    end

endmodule

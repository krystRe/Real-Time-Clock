`timescale 1ns / 1ps

module Seven_seg_decoder(
    input [3:0] input_digit,
    output reg [7:0] seg_set
    );

    always @(input_digit)
    begin
        case(input_digit)
            0: seg_set <= 8'b00000011; 
            1: seg_set <= 8'b10011111;
            2: seg_set <= 8'b00100101;
            3: seg_set <= 8'b00001101;
            4: seg_set <= 8'b10011001;
            5: seg_set <= 8'b01001001;
            6: seg_set <= 8'b11000001;
            7: seg_set <= 8'b00011111;
            8: seg_set <= 8'b00000001;
            9: seg_set <= 8'b00011001;
        endcase
    end
endmodule
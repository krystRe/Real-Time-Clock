`timescale 1ns / 1ps

module Display_driver(
    input clk_i,
    input rst_i,
    input [3:0] hr_left,
    input [3:0] hr_right,
    input [3:0] min_left,
    input [3:0] min_right,
    output reg [7:0] led7_an_o,
    output reg [7:0] led7_seg_o    
    );
    
    localparam LEFT = 2'b00;
    localparam MID_LEFT = 2'b01;
    localparam MID_RIGHT = 2'b10;
    localparam RIGHT = 2'b11;
    
    wire [7:0] seg1, seg2, seg3, seg4;
    reg [1:0] state = LEFT;
    reg blink;
    integer counter;
    integer counter2;
    always @(posedge clk_i or posedge rst_i)
    begin
        if(rst_i)
        begin
            counter = 1'b0;
            counter2 = 1'b0;
            state <= LEFT;
            blink <= 1'b0;
            led7_seg_o <= 8'b00000000;
            led7_an_o <= 8'b11110000;
        end
        
        else
        begin
            if(counter == 10000)
            begin
                case (state)
                    LEFT: begin
                            led7_seg_o <= seg1;
                            led7_an_o <= 8'b11110111;
                            state <= MID_LEFT;
                        end
                    MID_LEFT: begin
                            led7_seg_o[7:1] <= seg2[7:1];
                            led7_seg_o[0] <= blink;
                            led7_an_o <= 8'b11111011;
                            state <= MID_RIGHT;
                        end
                    MID_RIGHT: begin
                            led7_seg_o <= seg3;
                            led7_an_o <= 8'b11111101;
                            state <= RIGHT;
                        end
                    RIGHT: begin
                            led7_seg_o <= seg4;
                            led7_an_o <= 8'b11111110;
                            state <= LEFT;
                        end
                endcase
                counter = 0;
            end
            
            if(counter2 == 100000000)
            begin
                blink = ~blink;
                counter2 = 0;
            end
            
            counter = counter + 1;
            counter2 = counter2  + 1;
        end
    end 
    
    Seven_seg_decoder Display1(hr_left, seg1);
    Seven_seg_decoder Display2(hr_right, seg2);
    Seven_seg_decoder Display3(min_left, seg3);
    Seven_seg_decoder Display4(min_right, seg4);
    
endmodule

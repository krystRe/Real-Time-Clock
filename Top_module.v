`timescale 1ns / 1ps

module Top_module(
    input clk_i,
    input rst_i,
    input button_hr_i,
    input button_min_i,
    input button_test_i,
    output [7:0] led7_an_o,
    output [7:0] led7_seg_o    
    );
    
    wire [3:0] hr_left;
    wire [3:0] hr_right;
    wire [3:0] min_left;
    wire [3:0] min_right;
    wire set_hour, set_min, set_test;
    
    Debouncer hr_up(.clk_i(clk_i), .rst_i(rst_i), .button(button_hr_i), .debounced_signal(set_hour));
    Debouncer min_up(.clk_i(clk_i), .rst_i(rst_i), .button(button_min_i), .debounced_signal(set_min));
    Debouncer testing(.clk_i(clk_i), .rst_i(rst_i), .button(button_test_i), .debounced_signal(set_test));
    
    Main_clock Clock(.clk_i(clk_i), .rst_i(rst_i), .set_hour(set_hour), .set_min(set_min), .set_test(set_test), .hr_left(hr_left), .hr_right(hr_right), .min_left(min_left), .min_right(min_right));
    Display_driver Display(.clk_i(clk_i), .rst_i(rst_i), .hr_left(hr_left), .hr_right(hr_right), .min_left(min_left), .min_right(min_right), .led7_an_o(led7_an_o), .led7_seg_o(led7_seg_o));
endmodule

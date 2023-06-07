`timescale 1ns / 1ps

module Debouncer(
    input clk_i,
    input rst_i,
    input button,
    output reg debounced_signal
    );
    
    integer counter;
    integer bounce_time = 5000000;
    reg [2:0] state;
    
    always @(posedge clk_i or posedge rst_i)
    begin
        if(rst_i)
        begin
            counter = 0;
            state <= 0;
            debounced_signal <= 0;
        end
        else
        begin
            case(state)
                0: begin
                    counter = 0;
                    if(button)
                        state <= 1;
                    end
                1: begin 
                    debounced_signal <= 1;
                    if(counter == bounce_time)
                        state <= 2;
                        counter = counter + 1;
                    end
                2: begin
                    counter = 0;
                    if(!button)
                        state <= 3;
                    end    
                3: begin
                    debounced_signal <= 0;
                    if(counter == bounce_time)
                        state <= 4;
                        counter = counter + 1;
                    end
                4: state <= 0;
            endcase
        end
    end
endmodule

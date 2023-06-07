`timescale 1ns / 1ps

module Main_clock(
    input clk_i,
    input rst_i,
    input set_hour,
    input set_min,
    input set_test,
    output reg [3:0] hr_left,
    output reg [3:0] hr_right,
    output reg [3:0] min_left,
    output reg [3:0] min_right
    );
    
    integer counter;
    integer test;
    reg [5:0] seconds;
    reg set_test_state;
    reg new_test_state;
    reg set_hour_state;
    reg new_set_hour_state;
    reg set_min_state;
    reg new_set_min_state;
    
    
    always @(posedge set_test or posedge rst_i)
    begin
        if(rst_i)
            set_test_state <= 1'b0;
        else
            set_test_state <= ~set_test_state;
    end
    
    always @(posedge set_hour or posedge rst_i)
    begin
        if(rst_i)
            set_hour_state <= 1'b0;
        else
            set_hour_state <= ~set_hour_state;
    end
    
    always @(posedge set_min or posedge rst_i)
    begin
        if(rst_i)
            set_min_state <= 1'b0;
        else
            set_min_state <= ~set_min_state;
    end
    
    always @(posedge clk_i or posedge rst_i)
    begin
        if(rst_i)
        begin
            counter = 1'b0;
            test <= 100000000;
            seconds <= 5'b00000;
            new_test_state <= 1'b0;
            new_set_hour_state <= 1'b0;
            new_set_min_state <= 1'b0;
            hr_left <= 4'b0000;
            hr_right <= 4'b0000;
            min_left <= 4'b0000;
            min_right <= 4'b0000;
        end
        else
        begin
            //przyspieszenie
            if(new_test_state != set_test_state)
            begin
                counter = 0;
                new_test_state <= set_test_state;
                
                if(set_test_state == 1)
                test <= 100000;
                else if (set_test_state == 0)
                test <= 100000000;
            end
            //ustawianie godzin
            else if(new_set_hour_state != set_hour_state)
            begin
                new_set_hour_state <= set_hour_state;
                hr_right <= hr_right + 1;
            end
            //ustawianie minut 
            else if(new_set_min_state != set_min_state)
            begin
                new_set_min_state <= set_min_state;
                min_right <= min_right + 1;
            end
            
            //Licznik sekund
            if(counter ==  test)
            begin
                counter = 0;
                seconds <= seconds + 1;
            end
            
            //format HH.MM
            if (seconds == 60)
            begin
                seconds <= 0;
                min_right <= min_right + 1;
            end
            else if (min_right == 10)
            begin
                min_right <= 0;
                min_left <= min_left + 1;
            end
            else if (min_left == 6)
            begin
                min_left <= 0;
                hr_right <= hr_right + 1;
            end
            else if(hr_right == 10)
            begin
                hr_right <= 0;
                hr_left <= hr_left + 1;
            end
            else if(hr_left == 2 && hr_right == 4)
            begin
                hr_right <= 0;
                hr_left <= 0;
            end
        
            counter = counter + 1;
        end
    end 
    
endmodule

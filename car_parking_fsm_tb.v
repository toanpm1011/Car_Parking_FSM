`timescale 1ns/1ps
module car_parking_fsm_tb;
//input
    reg clk;
    reg rst_n;
    reg sensor_entrace;
    reg sensor_exit;
    reg password;
//output
    wire led_alert;
    wire led_available;
    wire led_wait;
//
car_parking_fsm U1 (.clk(clk), .rst_n(rst_n), .sensor_entrace(sensor_entrace), .sensor_exit(sensor_exit), 
                        .password(password), .led_alert(led_alert), .led_available(led_available), .led_wait(led_wait));
//
//clock init
initial begin
    rst_n = 0;
    sensor_entrace = 0;
    sensor_exit = 0;
    password = 0;
    #30 rst_n = 1;
    sensor_entrace = 1;
    #1000;
    sensor_entrace = 0;
    password = 1;
    #2000;
    sensor_exit =1;
end
//
initial begin
    clk = 0;
    forever #10 clk=~clk;
end
//input init

endmodule
module car_parking_fsm(clk, rst_n, sensor_entrace, sensor_exit, password, led_alert, led_available, led_wait);
// input
input clk, rst_n;  
input sensor_entrace; // 1 if detect car go in
input sensor_exit;  // 1 if detect car go out
input password;  // 1 if true, 0 if false

// output
output reg led_alert;
output reg led_available;
output reg led_wait;
// internal signal
reg [2:0] current_state, next_state;
// State encoding
parameter IDLE = 3'b000;
parameter WAIT_PASSWORD = 3'b001;
parameter RIGHT_PASS = 3'b010;
parameter WRONG_PASS = 3'b100;
parameter STOP = 3'b101;
//
// Next State
always@(posedge clk or negedge rst_n)
begin
	if(~rst_n)
		current_state <= IDLE;
	else 
		current_state <= next_state;
end
//
// Change State
always@(*)
begin
	case(current_state)
		IDLE:
		begin
			if (sensor_entrace) 
			next_state = WAIT_PASSWORD;
			else 
			next_state = IDLE;
		end
		WAIT_PASSWORD:
		begin
			if(password)
			next_state = RIGHT_PASS;
			else 
			next_state = WRONG_PASS;
		end
		RIGHT_PASS:
		begin
			if(sensor_exit==1 && sensor_entrace ==1 )
			next_state = STOP;
			else if (~sensor_exit)
			next_state = RIGHT_PASS;
			else if (sensor_exit==1 && sensor_entrace == 0)
			next_state = IDLE;
		end
		WRONG_PASS:
		begin
			if(password)
			next_state = RIGHT_PASS;
			else next_state = WRONG_PASS;
		end
		STOP:
		begin
			if(password)
			next_state = STOP;
			else 
			next_state = RIGHT_PASS;
		end
		default: next_state = IDLE;
	endcase
end
always@(posedge clk)
begin
	case(current_state)
	IDLE: begin
		led_alert = 1'b0;
		led_available = 1'b0;
		led_wait = 1'b0;
	end
	WAIT_PASSWORD: begin
		led_alert = 1'b0;
		led_available = 1'b0;
		led_wait = 1'b1; 
	end
	RIGHT_PASS: begin
		led_alert = 1'b0;
		led_available = 1'b1;
		led_wait = 1'b0; 
	end
	WRONG_PASS: begin
		led_alert = 1'b1;
		led_available = 1'b0;
		led_wait = 1'b0; 
	end
	STOP: begin
		led_alert = 1'b1;
		led_available = 1'b0;
		led_wait = 1'b1; 
	end
	//default: IDLE;
	endcase
end
endmodule


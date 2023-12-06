module gobackn(
  input wire clk,
  input wire rst,
  input wire [7:0] data_in,//8-bit input data
  output wire valid_out,//Signal indicating whether the module is currently sending data.
  input wire ack_in,//Acknowledgment signal from the receiver
  input wire valid_in// Valid data signal indicating that there is new data to be sent
);

  // Constants
  parameter DATA_WIDTH = 8;
  parameter WINDOW_SIZE = 4;  // Adjust as needed
  parameter MAX_SEQ_NUM = (1 << (WINDOW_SIZE + 1)) - 1;
//DATA_WIDTH: Parameter specifying the width of the input data (8 bits in this case)
//WINDOW_SIZE: Parameter specifying the size of the sliding window for the Go-Back-N protocol
//MAX_SEQ_NUM: Parameter calculating the maximum sequence number based on the window size
  // State definition
  typedef enum logic [1:0] {
    IDLE,
    SENDING,
    WAITING_ACK
  } SenderState;

  // Internal signals
  logic [WINDOW_SIZE-1:0] window;//window: Register representing the current window position
  logic [WINDOW_SIZE-1:0] sent;//sent: Register indicating which packets have been sent and are awaiting acknowledgment
  logic [WINDOW_SIZE-1:0] acked;//acked: Register indicating which packets have been acknowledged
  logic [2:0] seq_num;//seq_num: Register representing the current sequence number
  SenderState state;//State variable representing the current state of the FSM
  logic [DATA_WIDTH-1:0] buffer;//Register to store the input data
  logic [MAX_SEQ_NUM:0] sent_data;//Register to keep track of the data sent
  
  // FSM
  always_ff @(posedge clk or posedge rst) begin
    if (rst) begin
      state <= IDLE;
      window <= 0;
      sent <= 0;
      acked <= 0;
      seq_num <= 0;
      buffer <= 0;
      sent_data <= 0;
    end else begin
      case (state)
        IDLE://IDLE state transitions to the SENDING state when valid input data (valid_in) is detected
          if (valid_in) begin
            state <= SENDING;
            buffer <= data_in;
          end
        SENDING:
          if (sent[window] && acked[window]) begin
            window <= window + 1;
            if (window == WINDOW_SIZE) begin
              state <= WAITING_ACK;
            end
				//it checks if the packet at the current window position has been both sent and acknowledged. 
				//If so, it moves the window and transitions to the WAITING_ACK state when the window is full
          end
        WAITING_ACK:
          if (ack_in) begin
            acked[window] <= 1;
            if (window == 0) begin
              state <= SENDING;
            end
				// it waits for an acknowledgment (ack_in). When an acknowledgment is received, 
				//it marks the corresponding packet as acknowledged and moves the window. If the window is back to the first position,
				//it transitions back to the SENDING state
          end
      endcase
    end
  end

  // Output logic
  assign valid_out = (state == SENDING);
  //valid_out is assigned based on whether the module is in the SENDING state

endmodule

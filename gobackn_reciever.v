module gobackn_reciever (
  input logic clk, //Clock signal
  input logic reset, // Reset signal
  input logic [7:0] rx_data, //Received data (8 bits)
  input logic rx_valid, //Signal indicating valid received data
  output logic [2:0] ack // Acknowledgment signal (3 bits)
);
  // Parameters
  parameter N = 4; // Window size
  parameter SEQ_WIDTH = 3; // Sequence number width

  // States
  typedef enum logic [1:0] {
    IDLE,
    WAIT_FOR_PACKET
  } state_t;  //Enumerated type defining states (IDLE and WAIT_FOR_PACKET)

  // Internal signals
  logic [SEQ_WIDTH-1:0] expected_seq; //Expected sequence number for incoming packets

  logic [N-1:0] received; //Bitmask to track received packets within the window
  logic [2:0] ack_count; //Counter to keep track of the number of acknowledgments sent  
  state_t state; 

  // Registers
  reg [7:0] packet_buffer; //Buffer to hold the received packet temporarily

  // Initializations
  initial begin
    state = IDLE;
    expected_seq = 0;
    received = 4'b0000;
    ack_count = 3'b000;
    ack = 3'b000;
  end

  // State machine
  always_ff @(posedge clk or posedge reset) begin
    if (reset) begin
      state <= IDLE;
      expected_seq <= 0;
      received <= 4'b0000;
      ack_count <= 3'b000;
      ack <= 3'b000;
    end else begin
      case (state)
        IDLE:
          if (rx_valid) begin
            packet_buffer <= rx_data;
            state <= WAIT_FOR_PACKET;
          end
        WAIT_FOR_PACKET:
          if (rx_valid) begin
            if (rx_data[2:0] == expected_seq) begin
              // Packet received successfully
              
              // Update state and expected sequence number
              state <= IDLE;
              expected_seq <= (expected_seq + 1) % (1 << SEQ_WIDTH);

              // Update received bitmask
              received <= {received[N-2:0], 1'b1};

              // Update acknowledgment
              ack_count <= ack_count + 1;
              if (ack_count == N) begin
                ack_count <= 3'b000;
                ack <= received;
                received <= 4'b0000;
              end
            end else begin
              // Discard the packet, send duplicate acknowledgment
              ack <= received;
              state <= IDLE;
            end
          end
      endcase
    end
  end

endmodule

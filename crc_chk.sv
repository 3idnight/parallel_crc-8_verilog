module crc_chk (
  input clk,
  input reset,
  input [7:0] data_in,
  input data_read2,
  output reg valid,
  output reg [7:0] data_crc_out2
);
  
  reg [7:0] remainder;
  reg [7:0] LUT_index;
  reg [3:0] byte_count;
  reg data_ready;

  // Instantiate LUT
  wire [7:0] crcTable [0:255];
  crc_table lut_inst (.crcTable(crcTable));
  
  //LUT_index
  always @(posedge clk or posedge reset) begin
    if (reset) begin
      LUT_index <= 8'h0;
      remainder <= 8'h0;
    end
    else if (data_read2) begin
      LUT_index = data_in ^ remainder;
      $display("LUT: %h %h %h", remainder, data_in, LUT_index);
      remainder = crcTable[LUT_index];
      $display("CRC Calc: %h", remainder);
    end
  end
    
  //data_ready
  always @(posedge clk or posedge reset) begin
    if (reset) begin
      data_ready <= 1'b0;
    end
    else if (data_read2) begin
      if (byte_count == 4'h7) begin
        data_ready <= 1'b1;
      end
      else begin
        data_ready <= 1'b0;
      end
    end
  end
  
//   //byte_count
//   always @(posedge clk or posedge reset) begin
//     if (reset) begin
//       byte_count <= 4'h0;
//     end
//     else if (data_read2) begin
//       if (byte_count == 4'h10) begin
//         byte_count <= 4'h0;
//       end
//       else begin
//         byte_count <= byte_count + 1;
//       	$display("Byte Count: %h", byte_count);
//       end
//     end
//   end
  
  always @(posedge clk or posedge reset) begin
    if (reset) begin
      byte_count <= 4'h0;
    end
    else if (data_read2) begin
      byte_count <= byte_count + 1;
      $display("Byte Count: %h", byte_count);
    end
  end
  
  //data_crc_out2
  always @(posedge clk or posedge reset) begin
    if (reset) begin
      data_crc_out2 <= 8'h0;
    end
    else if (data_read2) begin
      data_crc_out2 <= remainder;
    end
  end
  
  //valid
  always @(posedge clk or posedge reset) begin
    if (reset) begin
      valid <= 1'b0;
    end
    if (byte_count == 4'h8) begin
      #0.1;
      if (remainder == 8'h0) begin
        valid <= 1'b1;
      end
      else begin
        valid <= 1'b0;
      end
    end
  end
  
endmodule

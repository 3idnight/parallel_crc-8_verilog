`include "LUT.sv"
`include "error_inj.sv"
`include "crc_chk.sv"

module crc_gen (
  input clk,
  input reset,
  input [7:0] data_in,
  input data_read1,
  output reg [7:0] data_crc_out,
  output reg data_ready
);
  
  reg [7:0] crc;
  reg [7:0] LUT_index;
  reg [2:0] byte_count;

  
  //instantiate LUT
  wire [7:0] crcTable [0:255];
  crc_table lut_inst (.crcTable(crcTable));
  
  //byte_count
  always @(posedge clk or posedge reset) begin
    if (reset) begin
      byte_count <= 3'h0;
    end
    else if (data_read1) begin
      byte_count <= byte_count + 1;
    end
  end
  
  //data_ready
  always @(posedge clk or posedge reset) begin
    if (reset) begin
      data_ready <= 1'b0;
    end
    else if (byte_count == 3'h7) begin
      data_ready <= 1'b1;
    end
    else begin
      data_ready <= 1'b0;
    end
  end
  
  //LUT_index and crc
  always @(posedge clk or posedge reset) begin
    if (reset) begin
      LUT_index <= 8'h0;
      crc <= 8'h0;
    end
    else if (data_read1) begin
      LUT_index = crc ^ data_in;
      crc = crcTable[LUT_index];
    end
  end
  
  //data_crc_out
  always @(posedge clk or posedge reset) begin
    if (reset) begin
      data_crc_out <= 8'h0;
    end
    else if (byte_count == 3'h7) begin
      data_crc_out <= crc;
      $display("CRC In (gen): %h", data_in);
    end
    else begin
      data_crc_out <= data_in;
      $display("CRC In (gen): %h", data_in);
    end
  end
    
endmodule

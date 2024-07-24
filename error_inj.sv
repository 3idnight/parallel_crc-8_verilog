module error_inj (
  input clk,
  input reset,
  input error,
  input [7:0] data_in,
  output reg [7:0] data_out
);
  
  //data_out
  always @(posedge clk or posedge reset) begin
    if (reset) begin
      data_out <= 8'h0;
    end
    else if (error) begin
      data_out <= data_in ^ 8'h1;
    end
    else begin
      data_out <= data_in;
      $display("Error pass: %h", data_in);
    end
  end
  
endmodule

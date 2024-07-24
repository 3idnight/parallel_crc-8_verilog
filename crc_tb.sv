module crc_tb;

  reg clk;
  reg reset;
  reg [7:0] data_in;
  reg data_read1;
  reg data_read2;
  reg error;
  wire [7:0] data_crc_out2;
  reg [7:0] data_crc_out;
  wire data_ready;
  wire valid;
  reg [7:0] data_out;
  
  crc_gen dut_gen (
    .clk(clk),
    .reset(reset),
    .data_in(data_in),
    .data_read1(data_read1),
    .data_crc_out(data_crc_out),
    .data_ready(data_ready)
  );
  
  error_inj dut_err (
    .clk(clk),
    .reset(reset),
    .error(error),
    .data_in(data_crc_out),
    .data_out(data_out)
  );
  
  crc_chk dut_chk (
    .clk(clk),
    .reset(reset),
    .data_in(data_out),
    .data_read2(data_read2),
    .valid(valid),
    .data_crc_out2(data_crc_out2)
  );
  
  initial begin
    clk = 0;
    forever #5 clk = ~clk;
  end
  
  initial begin
    // no error injection
    $display("Test Case 1: No Error Injection");
    reset = 1;
    data_in = 0;
    data_read1 = 0;
    data_read2 = 0;
    error = 0;
    
    @(posedge clk);
    reset = 0;
    data_read1 = 1;
    $display("Clock 0: %h", data_in);
    data_in = 8'h12;
    #10;
    data_read2 = 1;
    $display("Clock 1: %h", data_in);
    data_in = 8'h34;
    #10;
    $display("Clock 2: %h", data_in);
    data_in = 8'h56;
    #10;
    $display("Clock 3: %h", data_in);
    data_in = 8'h78;
    #10;
    $display("Clock 4: %h", data_in);
    data_in = 8'h9a;
    #10;
    $display("Clock 5: %h", data_in);
    data_in = 8'hbc;
    #10;
    $display("Clock 6: %h", data_in);
    data_in = 8'hDE;
    #10;
    $display("Clock 7");
    data_read1 = 0;
    #10;
    $display("Clock 8");
    #10;
    $display("Clock 9");
    #10;
    $display("Clock 10");
    data_read2 = 0;
    
    // error injection
    $display("\nTest Case 2: With Error Injection");
    reset = 1'b1;
    data_in = 0;
    data_read1 = 0;
    data_read2 = 0;
    error = 1;
    #10;
    reset = 0;
    data_read1 = 1;
    $display("Clock 0: %h", data_in);
    data_in = 8'h12;
    #10;
    data_read2 = 1;
    $display("Clock 1: %h", data_in);
    data_in = 8'h34;
    #10;
    $display("Clock 2: %h", data_in);
    data_in = 8'h56;
    #10;
    $display("Clock 3: %h", data_in);
    data_in = 8'h78;
    #10;
    $display("Clock 4: %h", data_in);
    data_in = 8'h9a;
    #10;
    $display("Clock 5: %h", data_in);
    data_in = 8'hbc;
    #10;
    $display("Clock 6: %h", data_in);
    data_in = 8'hDE;
    #10;
    $display("Clock 7");
    data_read1 = 0;
    #10;
    $display("Clock 8");
    #10;
    $display("Clock 9");
    #10;
    $display("Clock 10");
    data_read2 = 0;
    
    $display("Test Case 3: No Error Injection");
    reset = 1;
    data_in = 0;
    data_read1 = 0;
    data_read2 = 0;
    error = 0;
    
    #10;
    reset = 0;
    data_read1 = 1;
    $display("Clock 0: %h", data_in);
    data_in = 8'h12;
    #10;
    data_read2 = 1;
    $display("Clock 1: %h", data_in);
    data_in = 8'h22;
    #10;
    $display("Clock 2: %h", data_in);
    data_in = 8'h56;
    #10;
    $display("Clock 3: %h", data_in);
    data_in = 8'h7a;
    #10;
    $display("Clock 4: %h", data_in);
    data_in = 8'h9a;
    #10;
    $display("Clock 5: %h", data_in);
    data_in = 8'hbc;
    #10;
    $display("Clock 6: %h", data_in);
    data_in = 8'hDc;
    #10;
    $display("Clock 7");
    data_in = 9'h0;
    data_read1 = 0;
    #10;
    $display("Clock 8");
    #10;
    $display("Clock 9");
    #10;
    $display("Clock 10");
    data_read2 = 0;
    reset = 1'b1;
    #10;
    reset= 1'b0;
    #30;
    $finish;
  end
  
  initial begin
    $dumpfile("design.vcd");
    $dumpvars(0);
  end

endmodule

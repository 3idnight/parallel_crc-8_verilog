POLYNOMIAL = 0x1D  #x^8 + x^2 + x + 1
WIDTH = 8
TOPBIT = 1 << (WIDTH - 1)
def crc_remainder(dividend):
   remainder = dividend << (WIDTH - 8)
   for bit in range(8, 0, -1):
       if remainder & TOPBIT:
           remainder = (remainder << 1) ^ POLYNOMIAL
       else:
           remainder = (remainder << 1)
   return remainder & 0xFF
def generate_crc_table():
   crc_table = [crc_remainder(i) for i in range(256)]
   return crc_table
def save_crc_table_to_verilog(crc_table, filename="LUT.txt"):
   with open(filename, "w") as file:
       file.write("module crc_table(\n")
       file.write("    output reg [7:0] crcTable [0:255]\n")
       file.write(");\n\n")
       file.write("    initial begin\n")
       for i, value in enumerate(crc_table):
           file.write(f"        crcTable[{i:3}] = 8'h{value:02X};\n")
       file.write("    end\n\n")
       file.write("endmodule\n")
def main():
   crc_table = generate_crc_table()
   save_crc_table_to_verilog(crc_table)
if __name__ == "__main__":
   main()
   

`include "core.v"
`include "ramctlr.v"
`include "romctlr.v"
`include "vgactlr.v"
`include "clockctlr.v"

module riscv(
        inout [15:0] ram_link,
        inout [15:0] rom_link,
        input clk_in,
        output [2:0] led1,
        output [2:0] led2,
        output TxD,
        input RxD );
  wire [31:0] rom_address;
  wire [31:0] rom_read;
  wire [31:0] ram_address;
  wire [31:0] ram_read;
  wire [31:0] ram_write;
  wire clk;
  wire ram_write_enable;
  wire [31:0] cpu_vga_link;

  wire [15:0] rom_link;
  wire [15:0] ram_link;

  wire TxD_start;
  wire [7:0] TxD_data;

  wire RxD_data_ready;
  wire [7:0] RxD_data;

  wire alu_a;
  wire alu_b;
  wire alu_r;
  wire alu_opcode;

  core CORE(.ram_address(ram_address),
      .rom_address(rom_address),
      .data_in_ram(ram_read),
      .data_out_ram(ram_write),
      .data_in_rom(rom_read),
      .ram_enable_write(ram_write_enable),
      .vga_link(cpu_vga_link),
      .alu_a(alu_a),
      .alu_b(alu_b),
      .alu_r(alu_r),
      .alu_opcode(alu_opcode),
      .clk(clk));

  ramctlr RAM(.ram_link(ram_link),
      .cpu_link_address(ram_address),
      .cpu_link_read(ram_read),
      .cpu_link_write(ram_write),
      .write_enable(ram_write_enable),
      .clk(clk));

  romctlr ROM(.rom_link(rom_link),
      .cpu_link_read(rom_read),
      .cpu_link_address(rom_address),
      .clk(clk));

  alu ALU(.a(alu_a),
      .b(alu_b),
      .r(alu_r),
      .opcode(alu_opcode));

  vgactlr VGA(cpu_vga_link, led1, clk);
  clockctlr CLK(.clk_in(clk_in), .clk_out(clk));
endmodule

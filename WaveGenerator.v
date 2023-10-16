// Waveform generator
//   M-bit signed output amplitude

module WaveGenerator #(N = 32, M = 16)(
  input clk,
  input rst,
  input chirp_reverse,            // whether chirp is an up (0) or a down (1) chirp
  input [7:0] chirp_delay,        // delay control between chirps
  input [N-1:0] chirp_min_ctrl,   // minimum frequency control word
  input [N-1:0] chirp_max_ctrl,   // maximum frequency control word
  input [N-1:0] chirp_inc_rate,   // proportional frequency rate control word
  input [N-1:0] chirp_div_rate,   // inversely proportional frequency rate control word
  output reg [M-1:0] waveform,   // waveform output pin
);

// Submodule inputs
reg nco_reset;
reg [N-1:0] nco_ctrl;

// Submodule outputs
wire chirp_nco_reset;
wire [N-1:0] chirp_nco_ctrl;
wire [15:0] sin_out;

always @(posedge clk) begin
  nco_ctrl <= chirp_nco_ctrl;
  nco_reset <= chirp_nco_reset;
  waveform <= sin_out;
end

// Connect up modules
NCO #(.N(N)) NCO0 (
  .clk     ( clk       ), // input
  .rst     ( nco_reset ), // input
  .ctrl    ( nco_ctrl  ), // input [N-1:0]
  .sin_out ( sin_out   ) // output [15:0]
);

Chirp #(.N(N)) Chirp0 (
  .clk       ( clk             ), // input
  .rst       ( rst             ), // input
  .delay     ( chirp_delay     ), // input [7:0]
  .reverse   ( chirp_reverse   ), // input
  .min_ctrl  ( chirp_min_ctrl  ), // input [N-1:0]
  .max_ctrl  ( chirp_max_ctrl  ), // input [N-1:0]
  .inc_rate  ( chirp_inc_rate  ), // input [N-1:0]
  .div_rate  ( chirp_div_rate  ), // input [N-1:0]
  .nco_reset ( chirp_nco_reset ), // output
  .nco_ctrl  ( chirp_nco_ctrl  )  // output [N-1:0]
);
endmodule

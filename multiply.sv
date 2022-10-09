module mult(
  input logic [3:0] mcand,
  input logic [3:0] mplier,
  input logic clk,
  input logic reset_l,
  input logic start,
  output logic rdy,
  output logic [7:0] product
);
  
  logic [7:0] mcandReg;
  logic [3:0] mplierReg;
  logic [2:0] state;
  
  always_ff @(posedge clk, negedge reset_l) // controller state
    begin
      if (reset_l==0) state<=0;
      else
        begin
        if (state==0) state<=(start==1)?1:0;
        else if (state<=3) state<=state+1;
        else state <= 0;
        end
    end
  
  assign rdy=(state==0)?1:0;
  
  always_ff @(posedge clk) // multiplier register
    if (state==1) mplierReg<= mplier;
    else mplierReg<=mplierReg>>1;
        
  always_ff @(posedge clk) // multiplicand register
    if (state==1) mcandReg<={mcand};
    else mcandReg <= mcandReg;
  
  always_ff @(posedge clk) // product register
    if (state==1) product<=0;
    else if (state>1) product+=mplier;
    else product += mcandReg<<1;
  
endmodule


module top;
  
  logic clk, reset_l, start, rdy;
  logic [3:0] mcand, mplier;
  logic [7:0] product;
  
  mult m(mcand,mplier,clk,reset_l,start,rdy,product);
  
  initial
    begin
      clk=0;
      forever #4 clk=~clk;
    end
  
  initial
    begin
      $monitor("state=%d",m.state);
      reset_l=1;
      mcand=3;
      mplier=5;
      start=0;
      #1 reset_l=0;
      #1 reset_l=1;
      #6 start=1;
      @(posedge clk) start=0;
      @(posedge rdy) #1 $display("%d x%d =%d",mcand,mplier,product);
      #1 $finish;
    end
  
endmodule
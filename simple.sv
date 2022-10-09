// Code your design here
module simple(
  input logic a,
  input logic rst,
  input logic clk,
  output logic [1:0] q
);
  
  always_ff @(posedge clk)
    begin
    if (rst==1)
      q<=0;
    else case(q)
      0: q<=1;
      1: q<=a?2:1;
      2: q<=a?3:2;
      3: q<=a?2:0;
      endcase
    end
  
endmodule

// Code your testbench here
// or browse Examples
module testbench;
  
  logic a;
  logic clk;
  logic rst;
  logic [1:0] q;
  int numTrans;
  
  simple dut(a,rst,clk,q);
  
  initial  // Clock generator and monitor
    begin
      $monitor("time=%3d,numTrans=%2d,state=%0d",$time,numTrans,q);
      clk=0;
      forever #5 clk=~clk;
    end
  
  // Modify the followiwng initial statement
  // Do not modify the lines: @(posedge clk); numTrans++;
  // Between these lines you insert lines to change the input 'a'
  // so that the testbench follows the transitions given in
  // Problem 22 of the Midterm Exam 1
  initial
    begin
      rst=1; a=0; 
      numTrans=0;
      @(posedge clk); numTrans++;
      rst=0;
      @(posedge clk); numTrans++;
      @(posedge clk); numTrans++;
      a = 1;
      @(posedge clk); numTrans++;
      a = 0;
      @(posedge clk); numTrans++;
      a = 1;
      @(posedge clk); numTrans++;
      @(posedge clk); numTrans++;
      @(posedge clk); numTrans++;
      a = 0;
      @(posedge clk); numTrans++;
      #2
      $finish;
    end
      
endmodule
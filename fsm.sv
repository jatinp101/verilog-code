module fsm(
  input logic a,
  input logic reset_l,
  input logic clk,
  output logic [2:0] state
);
  
  always_ff @(posedge clk, negedge reset_l)
    begin
      if (reset_l==0) state <=0;
      else 
        begin
          case (state)
            0: state <= a ? 4 : 1;
            1: state <= a ? 3 : 2;
            2: state <= a ? 3 : 2;
            3: state <= 0;
            4: state <= a ? 0 : 4;
          endcase
        end
    end
endmodule

module top;
  
  logic clk;
  logic reset_l;
  logic [2:0] state;
  logic a;
  
  fsm f(a,reset_l,clk,state);
  
  initial
    begin
      clk=0;
      forever #5 clk=~clk;
    end
  
  initial
    begin
      reset_l=1;
      #1
      reset_l=0;
      #1
      reset_l=1;
      #1
      if (state==0) $display("Initial state: ok");
      a=0;
      @(posedge clk) #1 if (state==1) $display("Test 1: ok");
      
      a=0;
      @(posedge clk) #1 if (state==2) $display("Test 2: ok");
      
      a=0;
      @(posedge clk) #1 if (state==2) $display("Test 3: ok");
      
      a=1;
      @(posedge clk) #1 if (state==3) $display("Test 4: ok");
      
      a=0;
      @(posedge clk) #1 if (state==0) $display("Test 5: ok");
      
      a=0;
      @(posedge clk) #1 if (state==1) $display("Test 6: ok");
      
      a=1;
      @(posedge clk) #1 if (state==3) $display("Test 7: ok");
      
      a=1;
      @(posedge clk) #1 if (state==0) $display("Test 8: ok");
      
      a=1;
      @(posedge clk) #1 if (state==4) $display("Test 9: ok");
      
      a=0;
      @(posedge clk) #1 if (state==4) $display("Test 10: ok");
   
      a=1;
      @(posedge clk) #1 if (state==0) $display("Test 11: ok");
      
      $finish;
    end
  
endmodule
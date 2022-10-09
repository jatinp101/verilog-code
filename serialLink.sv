// Code your design here
module sender(
  input logic [3:0] dataIn,
  input logic reset,
  input logic start,
  input logic clk,
  output logic serialOut
);

  logic [4:0] dataBuffer;
  logic [2:0] state;
  
  always_ff @(posedge clk)
    begin
      if (reset==1)
        begin
          dataBuffer<=0;
        end
      else if (state==0 && start==1)
        begin
          dataBuffer<={1'b1,dataIn};
        end
      else 
        begin
          dataBuffer<=dataBuffer<<1;
        end
    end
  
  assign serialOut=dataBuffer[4];
  
  always_ff @(posedge clk)
    begin
      if (reset==1) 
        begin
          state<=0;
        end
      else if (state==0 && start==1)
        begin
          state<=1;
        end
      else if (state>=1 && state<=4)
        begin
          state<=state+1;
        end
      else
        begin
          state<=0;
        end
    end
  
endmodule

module recver(
  input logic serialIn,
  input logic reset,
  input logic clk,
  output logic rdy,
  output logic [3:0] dataOut
);

  logic start=0;
  logic [4:0] dataBuffer;
  logic [2:0] state;
  
  always_ff @(posedge clk)
    begin
      if (reset==1)
        begin
          dataBuffer<=0;
          start<=0;
          rdy<=1;
        end
      else if (start == 0 && serialIn==1)
        begin
          start<=1;
          rdy<=0;
        end
      else if (start==1 && state<=3)
        begin
          dataBuffer<=dataBuffer<<1;
          dataBuffer[0]<=serialIn;
          
          if (state==3)
            begin
              start<=0;
          	  rdy<=1;
            end
        end
    end
  
  assign dataOut=dataBuffer;
  
  always_ff @(posedge clk)
    begin
      if (reset==1) 
        begin
          state<=0;
        end
      else if (state==0 && start==1)
        begin
          state<=1;
        end
      else if (state>=1 && state<=3)
        begin
          state<=state+1;
        end
      else
        begin
          state<=0;
        end
    end
  
  
endmodule
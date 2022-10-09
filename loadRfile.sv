// Code your design here
module regFile(
  output logic [3:0] rfdata,
  input logic [1:0] rfaddr,
  input logic [3:0] wdata,
  input logic [1:0] waddr,
  input logic write,
  input logic clk
);

  logic [3:0] regArray [0:3];
  
  assign rfdata=regArray[rfaddr];
  
  always_ff @(posedge clk)
    if (write==1) regArray[waddr]<=wdata;
  
endmodule

module transmitter(
  output logic serialLink,
  input logic [1:0] taddr,
  input logic [3:0] tdata,
  input logic send,
  input logic rst,
  input logic clk
);
  
  logic [4:0] state;
  logic [6:0] transBuff;
  
  always_ff @(posedge clk)
    begin
      if (rst==1) state<=0;
      else if (state==0 && send==1) state<=1;
      else if (state>0 && state<=7) state<=state+1;
      else state<=0;
    end
  
  always_ff @(posedge clk)
    begin
      if (rst==1) transBuff=0;
      else if (state==0 && send==1)
        transBuff<={1'b1,taddr,tdata};
      else transBuff<=transBuff<<1;
    end
  
  assign serialLink=transBuff[6];

endmodule

module rfileReceiver(
  output logic [1:0] waddr,
  output logic [3:0] wdata,
  output logic write,
  input logic serialLink,
  input logic rst,
  input logic clk
);
  
  logic ready;
  logic [6:0] transBuff;
  logic [4:0] state;

  always_ff @(posedge clk)
    begin
      if (rst==1)
        begin
          transBuff<=0;
          ready<=1;
        end
      else if (state == 0 && serialLink==1)
        begin
          transBuff[0]<=serialLink;
          ready<=0;
        end
      else if (ready==1)
        begin
          ready<=0;
          transBuff<=0;
        end
      else if (state > 0 && ready==0)
        begin
          transBuff<=transBuff<<1;
          transBuff[0]<=serialLink;
          if (state==6)
            begin
              ready<=1;
            end
        end
    end

  
  always_ff @(posedge clk)
    begin
      if (rst==1) 
        begin
          state<=0;
        end
      else if (state==0 && serialLink==1)
        begin
          state<=1;
        end
      else if (state>=1 && state<=6)
        begin
          state<=state+1;
        end
      else
        begin
          state<=0;
        end
    end
  
    
  assign waddr=transBuff[5:4];
  assign wdata=transBuff[3:0];
  assign write=transBuff[6];


endmodule
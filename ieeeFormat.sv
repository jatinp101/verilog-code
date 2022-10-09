 function logic [31:0] ieeeFormat
  (input logic s, 
   input logic [7:0] expo,
   input logic [22:0] mantissa
  );
    ieeeFormat[31]=s;
    ieeeFormat[30:23]=expo+127;
    ieeeFormat[22:0]=mantissa;
  endfunction

typedef enum logic [1:0] {xGTy=0, xEQy=1, xLTy=2,noResult=3} compareResults;

module compare
  (input logic [31:0] valueX,
   input logic [31:0] valueY,
   output compareResults result
  );
  
always_comb
  begin
    if (valueX[31] > valueY[31]) result=xLTy;
    else if (valueX[31] < valueY[31]) result = xGTy;
    else
      begin
        if (valueX[31] == 1'b1 && valueY[31] == 1'b1)
          begin
            if (valueX[30:23] < valueY[30:23]) result=xGTy;
            else if (valueX[30:23] > valueY[30:23]) result = xLTy;
        	else
          		begin
                  if (valueX[22:0] < valueY[22:0]) result=xGTy;
                  else if (valueX[22:0] > valueY[22:0]) result = xLTy;
            		else result=xEQy;
          		end
           end
        else if (valueX[30:23] > valueY[30:23]) result=xGTy;
        else if (valueX[30:23] < valueY[30:23]) result = xLTy;
        else
          begin
            if (valueX[22:0] > valueY[22:0]) result=xGTy;
        	else if (valueX[22:0] < valueY[22:0]) result = xLTy;
            else result=xEQy;
          end
      end
  end
  
endmodule

module top;
  logic [31:0] valX;
  logic [31:0] valY;
  compareResults result;
  
  compare dut(valX,valY,result);
  
  initial begin
    valX=ieeeFormat(0,2,77);
    valY=ieeeFormat(0,2,77);
    #2
    if (result==xEQy) $display("Test1 xEQy: okay");
    #2
    valX=ieeeFormat(1,-2,97);
    valY=ieeeFormat(1,-2,97);
    #2
    if (result==xEQy) $display("Test2 xEQy: okay");  
    #2
    valX=ieeeFormat(0,-2,97);
    valY=ieeeFormat(1,-3,97);
    #2
    if (result==xGTy) $display("Test3 xGYy: okay"); 
    #2
    valX=ieeeFormat(0,-2,97);
    valY=ieeeFormat(0,-3,97);
    #2
    if (result==xGTy) $display("Test4 xGYy: okay"); 
    #2
    valX=ieeeFormat(1,-5,97);
    valY=ieeeFormat(1,-3,97);
    #2
    if (result==xGTy) $display("Test5 xGYy: okay"); 
    #2
    valX=ieeeFormat(1,-2,997);
    valY=ieeeFormat(0,-2,97);
    #2
    if (result==xLTy) $display("Test6 xLTy: okay"); 
    #2
    valX=ieeeFormat(0,-5,97);
    valY=ieeeFormat(0,-3,997);
    #2
    if (result==xLTy) $display("Test7 xLTy: okay"); 
    #2
    valX=ieeeFormat(1,-2,97);
    valY=ieeeFormat(1,-3,97);
    #2
    if (result==xLTy) $display("Test8 xLTy: okay"); 
    #2
    
    $finish;
    
  end
  
endmodule

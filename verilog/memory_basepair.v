`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    17:39:44 12/02/2016 
// Design Name: 
// Module Name:    memory_basepair 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module memory_basepair(clk,reference,reset,shortread,index,sequence,start,index_done);

input clk,reset;
input [99:0] reference;
output reg [15:0] sequence;
input [15:0] shortread;
reg[7:0] count=  0;
reg[7:0] countshortread = 0;
integer a_pointer,t_pointer,c_pointer,g_pointer,count_max=93,count_shortreadmax = 12;
reg done;
output reg[7:0] index;
output reg start;
integer i=0,j=0,k=0,l=0;  
output reg index_done ;

//reg [19:0] sequence;
reg [99:0] ref;
reg [15:0]short_read;

reg [15:0] mem_a [0:60];    
reg [15:0] mem_t [0:60];     
reg [15:0] mem_g [0:60];   
reg [15:0] mem_c [0:60];
reg [15:0] tempreg_a;
reg [15:0] tempreg_t;
reg [15:0] tempreg_g;
reg [15:0] tempreg_c;
reg [1:0] extracted_bits;

always@(posedge clk or posedge reset)
begin
if(reset)
begin
ref <= reference;
a_pointer<=0;t_pointer<=0;c_pointer<=0;g_pointer<=0;
short_read <= shortread;
tempreg_a=0;   
tempreg_t=0;
tempreg_g=0;
tempreg_c=0;

end
else
begin
    if (count<count_max)   
    begin
    
      
    case(ref[count +: 2])
    2'b00:
    begin
    mem_a[a_pointer] <= {ref[count  +:8] , count};
    a_pointer <= a_pointer + 1;  
    end
    2'b10:
    begin  
    mem_c[c_pointer] <= {ref[count  +:8] , count};
    c_pointer <= c_pointer + 1;
    end
    2'b01:
    begin
    mem_g[g_pointer] <= {ref[count  +:8] , count};
    g_pointer <= g_pointer + 1;
    end
    default:
    begin
    mem_t[t_pointer] <= {ref[count  +:8] , count};
    t_pointer <= t_pointer + 1;
    end
    endcase
    count <= count + 2'b10;
    end
    else  
    begin
    count <= count;
    done <= 1'b1;
    
    end
end
end  

always@(posedge clk or posedge reset)
    if(reset)
    begin
	 	 start<=0;	
    index = 8'b00000000;
	 	 index_done <= 0;
		 	 sequence = 20'd0;

    end
	 else begin
    if (done == 1'b1)
    begin

    start <= 0;
    i = 0;
    j = 0;
    k = 0;
    l = 0;
    tempreg_a = 0;
    tempreg_t = 0;
    tempreg_g = 0;
    tempreg_c = 0;
    
        if (countshortread <count_shortreadmax)
        begin
        
        extracted_bits <= short_read[countshortread +: 2];
        case(short_read[countshortread +: 2])
        
        2'b00:   
        begin
        for (  l = 0;l <61; l = l+1)
        begin
        tempreg_a = mem_a[l];
        if(short_read[countshortread +: 8]==tempreg_a[8 +:8])
        begin
        if(tempreg_a[7:0] - countshortread >= 0)
			  if(tempreg_a[7:0] - countshortread > 80)
		  index = index;
		  else
		  begin
        index = tempreg_a[7:0] - countshortread;
		  sequence = ref[index +: 20];
        start <= 1;
		  end
        end
        end
        end
        
        
        2'b10:
        begin
        for (  i = 0;i <61; i = i+1)
        begin
        tempreg_c = mem_c[i];
        if(short_read[countshortread +: 8]==tempreg_c[8 +:8])
        begin
        if(tempreg_c[7:0] - countshortread >= 0)
	      if(tempreg_c[7:0] - countshortread > 80)
		  index = index;
		  else
		  begin
        index = tempreg_c[7:0]- countshortread;
		  sequence = ref[index +: 20];
        start <= 1;
		  end
        
        end
        end
        end  

        2'b01:
        begin
        for (  j = 0;j <61; j = j+1)
        begin
        tempreg_g = mem_g[j];
        if(short_read[countshortread +: 8]==tempreg_g[8 +:8])
        begin
        if(tempreg_g[7:0] - countshortread >= 0)
		  if(tempreg_g[7:0] - countshortread > 80)
		  index = index;
		  else
		  begin
        index = tempreg_g[7:0] - countshortread;
		  sequence = ref[index +: 20];
        start <= 1;
		  end
        end
        end
        end

        default:
        begin
        for (  k = 0;k <61; k = k+1)
        begin  
        tempreg_t = mem_t[k];
        if(short_read[countshortread +: 8]==tempreg_t[8 +:8])
        begin
        if(tempreg_t[7:0] - countshortread >= 0)
		  if(tempreg_t[7:0] - countshortread > 80)
		  index = index;
		  else
		  begin
        index = tempreg_t[7:0]- countshortread;
		  sequence = ref[index +: 20];
        start <= 1;
		  end
        end    
        end 
        end

endcase
countshortread <= countshortread + 2'b10;
end
else
begin
countshortread <= countshortread ;
index_done <= 1;

end
end
end


endmodule


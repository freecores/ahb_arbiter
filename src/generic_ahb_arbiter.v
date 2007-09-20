//****************************************************************************************************** 
// Copyright (c) 2007 TooMuch Semiconductor Solutions Pvt Ltd. 
//File name : generic_ahb_arbiter.v 
//Designer :Ankur Rawat 
//Date : 20 Sep, 2007 
//Test Bench description :Generic AMB AHBA complain Arbiter. 
//Revision : 1.0 
//****************************************************************************************************** 

	    
module	generic_arbiter_full(busreq,hlock,hclk,hreset,hmaster_lock,hgrant,hready,hwdata,data_out,haddr,addr_out,hburst,htrans,htrans_out,hburst_out,hmaster);

	parameter size=9;
	parameter size_out=4;

	integer i;

	input [8*size-1:0]hwdata;
	input [8*size-1:0]haddr;
	input [3*size-1:0]hburst;
	input [2*size-1:0]htrans;
	input hclk;
	input hreset;
	input hready;
	input  [size-1:0]busreq;
	input [size-1:0]hlock;

	output reg [2:0]hburst_out;
	output reg [1:0]htrans_out;
	output reg hmaster_lock;
	output reg  [size_out-1:0]hgrant;
	output reg [7:0]data_out;
	output reg [7:0]addr_out;
	output reg [size_out-1:0]hmaster;

	reg [8*size-1:0]data1;
	reg [8*size-1:0]addr1;
	reg [8*size-1:0]data2;
	reg [8*size-1:0]addr2;
	reg [3*size-1:0]hburst1;
	reg [2*size-1:0]htrans1;
	reg [3*size-1:0]hburst2;
	reg [2*size-1:0]htrans2;
	reg  [size_out-1:0]w_hgrant;
	reg  w_hlock;
	reg hmasterlock;
	reg hlock3;    
	reg [size_out-1:0]j;
	reg [size_out-1:0]inter;
	reg inter1;
	reg [size_out-1:0]hmaster_pre;
	reg hlock_c;
	reg [4:0]count;
	reg [4:0]counter;
	reg hlock_out;
	reg hlock_bus;


always@(posedge hclk)
	begin
		hmaster_pre<=hmaster;
	end


always@(hlock or hgrant or hmaster_lock or hlock3)
	begin
		hlock_out=hlock>>hgrant;
		if(hmaster_lock)	
			begin
				hlock_bus=hlock_out;
			end
		else
			begin
				hlock_bus=hlock3;
			end

	end








always @(busreq or hlock)
        begin
        	inter=4'b1000;inter1=0;
			for (j = size; j >= 1; j = j - 1)
				begin
					if (busreq[j-1]==1)
						begin
                                                 	w_hgrant = j-1;
                                                 	inter=j-1;
                            				w_hlock=hlock[j-1];
                            				inter1=hlock[j-1];
                                           	end
                                  	else
                                     		begin
                                                 	w_hgrant=inter;
                            				w_hlock=inter1;
                                       		end
                         	end


	end


always@(posedge hclk)
    	begin
         	  if(!hreset)
            		begin
                		hgrant<=1'b0;
           			hlock3<=1'b0; 

            		end

         	else    if(!hmasterlock)
                     		begin
                           		hgrant<=w_hgrant;
                           		hlock3<=w_hlock;	
                     		end

        end



always@(hmaster_lock )
    	begin
              hmasterlock=hmaster_lock;   
        end


always@(posedge hclk)
	begin
		if(!hreset)
                   	begin
                      		hmaster=1'b0;
                      		hlock_c =1'b0;
                   	end

      		else    if(hready)
              			begin
              				hmaster=hgrant;
              				hlock_c=hlock_bus;
             			end
    	end





always@(hmaster,addr2,htrans2,hburst2)
	begin
		addr_out<=addr2>>8*hmaster;
		htrans_out<=htrans2>>2*hmaster;
		hburst_out<=hburst2>>3*hmaster;
	end


always@(hmaster_pre or data2)
	begin
		data_out<=data2>>8*hmaster_pre;

	end

always@(posedge hclk)
	begin
                 if(hready)
        	        begin
                       		data2<=data1;addr2<=addr1;htrans2<=htrans1;hburst2<=hburst1;
                	end
	end

always@(posedge hclk)
	begin
		data1<=hwdata;addr1<=haddr;htrans1<=htrans;hburst1<=hburst;
               
	end


always@(posedge hclk)
	begin
                 if(!hreset)
	                      begin
	                             hmaster_lock=1'b0;
	                             counter=5'b00000;
	                             count=5'b00000;
	                      end


		else        
		             begin
		                       case(hburst_out)
	                                3'b000,3'b001:begin
	                                               if(counter==5'b00000)
				                            begin
	                        			            counter=5'b00000; 
                                                        	    hmaster_lock=hlock_c;

				                            end
                                			   end
                                        3'b010,3'b011:begin 
                                        	      if(counter==5'b00000)
                            					begin 
                                					counter=5'b00100;
                                                            		hmaster_lock=1'b1;
                                                                 	count=5'b00000;
                            					end   
                                   			end
                                        3'b100,3'b101:begin 
                                           		if(counter==5'b00000)
                            					begin 
                                					counter=5'b01000; 
                                                            		hmaster_lock=1'b1;
                                                                	count=5'b00000; 
                            					end   
                               				end
                                        3'b110,3'b111:begin 
                                       			if(counter==5'b00000)
                        					begin 
                            						counter=5'b10000; 
                                                        		hmaster_lock=1'b1;
                                                        		count=5'b00000;
                        					end   
                               end
					endcase

	case(htrans_out) 
		        2'b00 ,2'b01 :begin
                  				if ((count+3)<=counter)
                      					begin  
                            					count=count+1; 
                      					end 
              					else if ((count+3)>counter && ((count+1)<counter) )
							begin
		  						hmaster_lock=hlock_c;
								count=count+1;
							end
			
						else
                       					begin
                          					counter=5'b00000;
                           					hmaster_lock=hlock_c;
                           					count=5'b0000;
                       					end
              				end 
             			default: count=count;      
        
        endcase
	end
	end
endmodule
 


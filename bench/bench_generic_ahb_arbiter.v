//****************************************************************************************************** 
// Copyright (c) 2007 TooMuch Semiconductor Solutions Pvt Ltd. 
//File name : bench_generic_ahb_arbiter.v 
//Designer :Ankur Rawat 
//Date : 20 Sep, 2007 
//Test Bench description : Test bench for the Generic AMB AHBA complain Arbiter:-  . 
//Revision : 1.0 
//****************************************************************************************************** 
module  bench_generic_arbiter_full();
reg  [2:0]k1;

	integer i1;
	integer i2;
	integer i;

	parameter size=9;
	parameter size_out=4;


	reg [8*size-1:0]data_in;
	reg [8*size-1:0]addr_in;
	reg [3*size-1:0]hburst;
	reg [2*size-1:0]htrans;
	reg clock;
	reg reset;
	reg hready;
	reg [size-1:0]busreq;
	reg [size-1:0]hlock_main;

	wire [2:0]hburst_out;
	wire [1:0]htrans_out;
	wire hmaster_lock;
	wire [size_out-1:0]hgrant;
	wire [size_out-1:0]hmaster;
	wire [7:0]data_out;
	wire [7:0]addr_out;

always
	begin
#5		clock=~clock;
	end


initial
	begin
#2000 		$finish;		
	end


always@(posedge clock)
	begin

		
		#10		$display("data_out = %d addr_out = %d ",data_out,addr_out);
			
	end


initial
	begin
		data_in[7:0]=8'b0000_0001;
		data_in[15:8]=8'b0000_0010;
		data_in[23:16]=8'b0000_0011;
		data_in[31:24]=8'b0000_0100;
		data_in[39:32]=8'b0000_0101;
		data_in[47:40]=8'b0000_0110;
		data_in[55:48]=8'b0000_0111;
		data_in[63:56]=8'b0000_1000;
  		data_in[71:64]=8'b0000_1001;
		addr_in[7:0]=8'b0000_0001;
		addr_in[15:8]=8'b0000_0010;
		addr_in[23:16]=8'b0000_0011;
		addr_in[31:24]=8'b0000_0100;
		addr_in[39:32]=8'b0000_0101;
		addr_in[47:40]=8'b0000_0110;
		addr_in[55:48]=8'b0000_0111;
		addr_in[63:56]=8'b0000_1000;
  		addr_in[71:64]=8'b0000_1001;
		reset=0;
		busreq=0;
		hburst=0;
		htrans=0;
		hready=1;
		clock=0;
#25		reset=1;
#1		busreq[0]=0;
		hlock_main=9'b0_0000_0000;
		
	fork
		wrap_8_m0;
		wrap_16_m1;
	join

#10	wrap_4_m0;
	$display("time1 ******************");

#10	wrap_16_m0;
$display("time2 ************************ %5d" ,$time);


#10 	wrap_16_m1;
	$display("time3 ************************ %5d" ,$time);

#10 	wrap_8_m1;	
$display("time4 ************************ %5d" ,$time);


#10  wrap_8_m2;
$display("time5 ************************ %5d" ,$time);

#10  wrap_8_m3;
$display("time6 ************************ %5d" ,$time);

#10  wrap_8_m4;
$display("time7 ************************ %5d" ,$time);
	end



task wrap_8_m4;
	begin
		$display("wrap_8_m4");
#50		htrans=0;
		htrans[7:6]=2'b00;hburst[11:9]=3'b100;hlock_main[3]=1;busreq[3]=1'b1;data_in[39:32]=data_in[39:32]+2'b11;
	wait(hgrant==4'b0011);
	
	for(i=0;i<=4;i=i+1)
		begin
#10			htrans[7:6]=2'b01;hburst[11:9]=3'b100;hlock_main[3]=0;busreq[3]=1'b1;data_in[39:32]=data_in[39:32]+1;
		end


#10		htrans[7:6]=2'b01;hburst[11:9]=3'b000;hlock_main[3]=0;busreq[3]=1'b0;data_in[39:32]=data_in[39:32]+1;
#10		htrans[7:6]=2'b01;hburst[11:9]=3'b000;hlock_main[3]=0;busreq[3]=1'b0;data_in[39:32]=data_in[39:32]+1;

	end
endtask



task wrap_8_m3;
	begin
		htrans=0;
		$display("wrap_8_m4");
		htrans[7:6]=2'b00;hburst[11:9]=3'b100;hlock_main[3]=1;busreq[3]=1'b1;data_in[31:24]=data_in[31:24]+2'b11;

	wait(hgrant==4'b0011);
	
	for(i=0;i<=4;i=i+1)
		begin
#10			htrans[7:6]=2'b01;hburst[11:9]=3'b100;hlock_main[3]=0;busreq[3]=1'b1;data_in[31:24]=data_in[31:24]+1;

			
		end

#10		htrans[7:6]=2'b01;hburst[11:9]=3'b000;hlock_main[3]=0;busreq[3]=1'b0;data_in[31:24]=data_in[31:24]+1;
#10		htrans[7:6]=2'b01;hburst[11:9]=3'b000;hlock_main[3]=0;busreq[3]=1'b0;data_in[31:24]=data_in[31:24]+1;

	end
endtask


task wrap_8_m2;
	begin
		htrans=0;
		htrans[5:4]=2'b00;hburst[8:6]=3'b100;hlock_main[2]=1;busreq[2]=1'b1;data_in[23:16]=data_in[23:16]+2'b11;

	wait(hgrant==4'b0010);
	
	for(i=0;i<=4;i=i+1)
		begin
#10			htrans[5:4]=2'b01;hburst[8:6]=3'b100;hlock_main[2]=0;busreq[2]=1'b1;data_in[23:16]=data_in[23:16]+1;

			
		end
#10		htrans[5:4]=2'b01;hburst[8:6]=3'b000;hlock_main[2]=0;busreq[2]=1'b0;data_in[23:16]=data_in[23:16]+1;
#10		htrans[5:4]=2'b01;hburst[8:6]=3'b000;hlock_main[2]=0;busreq[2]=1'b0;data_in[23:16]=data_in[23:16]+1;
	end
endtask


task wrap_8_m0;
	begin
		htrans=0;
		htrans[1:0]=2'b00;hburst[2:0]=3'b100;hlock_main[0]=1;busreq[0]=1'b1;data_in=data_in;addr_in=addr_in+2'b11;

	wait(hgrant==4'b0000);
	
	for(i=0;i<=4;i=i+1)
		begin
#10			htrans[1:0]=2'b01;hburst[2:0]=3'b100;hlock_main[0]=0;busreq[0]=1'b1;data_in=data_in+1'b1 ;addr_in=addr_in+2'b01;

	
		end
#10		htrans[1:0]=2'b01;hburst[2:0]=3'b000;hlock_main[0]=0;busreq[0]=1'b0;data_in=data_in+1;addr_in=addr_in+2'b01;
#10		htrans[1:0]=2'b01;hburst[2:0]=3'b000;hlock_main[0]=0;busreq[0]=1'b0;data_in=data_in+1;addr_in=addr_in+2'b01;


	end
endtask

task wrap_4_m0;
	begin
		htrans=0;
		$display("wrap_4_mo");
		htrans[1:0]=2'b00;hburst[2:0]=3'b010;hlock_main[0]=1;busreq[0]=1'b1;data_in=data_in+2'b11;
	wait(hgrant==4'b0000);
#10	htrans[1:0]=2'b01;hburst[2:0]=3'b000;hlock_main[0]=0;busreq[0]=1'b0;data_in=data_in+1;
#10	htrans[1:0]=2'b01;hburst[2:0]=3'b000;hlock_main[0]=0;busreq[0]=1'b0;data_in=data_in+1;
#10	htrans[1:0]=2'b01;hburst[2:0]=3'b000;hlock_main[0]=0;busreq[0]=1'b0;data_in=data_in+1;
	end
endtask

task wrap_16_m0;
	begin
		htrans=0;
		$display("wrap_16_mo");
		htrans[2:0]=2'b00;hburst[2:0]=3'b111;hlock_main[0]=1;busreq[0]=1'b1;data_in=data_in+2'b11;

		 wait(hgrant==4'b0000);
			for(i=0;i<13;i=i+1)
				begin
#10					htrans[1:0]=2'b01;hburst[2:0]=3'b111;hlock_main[0]=1;busreq[0]=1'b0;data_in=data_in+1;
				end

#10	htrans[1:0]=2'b01;hburst[2:0]=3'b000;hlock_main[0]=0;busreq[0]=1'b0;data_in=data_in+1;
#10	htrans[1:0]=2'b01;hburst[2:0]=3'b000;hlock_main[0]=0;busreq[0]=1'b0;data_in=data_in+1;
	end
endtask

task wrap_16_m1;
	begin
		htrans=0;
		$display("wrap_16_m1");
		busreq[1]=1'b1;htrans[3:2]=2'b00;hburst[5:3]=3'b111;hlock_main[1]=1;data_in[15:8]=data_in[15:8]+2'b11;addr_in[15:8]=addr_in[15:8]+2'b11;

		 wait(hgrant==4'b0001);
#10			busreq[1]=1'b1;htrans[3:2]=2'b01;hburst[5:3]=3'b111;hlock_main[1]=1;data_in[15:8]=data_in[15:8]+1;addr_in[15:8]=addr_in[15:8]+1'b1 ;
			for(i=0;i<12;i=i+1)
				begin
#10					busreq[1]=1'b0;htrans[3:2]=2'b01;hburst[5:3]=3'b000;hlock_main[1]=0;data_in[15:8]=data_in[15:8]+1;addr_in[15:8]=addr_in[15:8]+1'b1 ;
				end

#10		busreq[1]=1'b0;htrans[3:2]=2'b11;hburst[5:3]=3'b000;hlock_main[1]=0;data_in[15:8]=data_in[15:8];addr_in[15:8]=addr_in[15:8]; 
#10		busreq[1]=1'b0;htrans[3:2]=2'b11;hburst[5:3]=3'b000;hlock_main[1]=0;data_in[15:8]=data_in[15:8];addr_in[15:8]=addr_in[15:8]; 
#10		busreq[1]=1'b0;htrans[3:2]=2'b01;hburst[5:3]=3'b000;hlock_main[1]=0;data_in[15:8]=data_in[15:8]+1;addr_in[15:8]=addr_in[15:8]+1'b1 ;
#10		busreq[1]=1'b0;htrans[3:2]=2'b01;hburst[5:3]=3'b000;hlock_main[1]=0;data_in[15:8]=data_in[15:8]+1;addr_in[15:8]=addr_in[15:8]+1'b1 ;




	end

endtask

task wrap_8_m1;
	begin
		htrans=0;
		$display("wrap_16_m1");

		busreq[1]=1'b1;htrans[3:2]=2'b00;hburst[5:3]=3'b100;hlock_main[1]=1;data_in[15:8]=data_in[15:8]+2'b11;
			 wait(hgrant==4'b0001);
				for(i=0;i<4;i=i+1)
					begin
#10						busreq[1]=1'b0;htrans[3:2]=2'b01;hburst[5:3]=3'b100;hlock_main[1]=1;data_in[15:8]=data_in[15:8]+1;
					end

#10		busreq[1]=1'b0;htrans[3:2]=2'b01;hburst[5:3]=3'b000;hlock_main[1]=0;data_in[15:8]=data_in[15:8]+1;
#10		busreq[1]=1'b0;htrans[3:2]=2'b01;hburst[5:3]=3'b000;hlock_main[1]=0;data_in[15:8]=data_in[15:8]+1;
	end

endtask



task wrap_4_m1;
	begin
		htrans=0;
		$display("wrap_4_m1");
		htrans[1:0]=2'b00;hburst[2:0]=3'b100;hlock_main[1]=1;busreq[1]=1'b1;data_in[15:8]=data_in[15:8]+2'b11;
			 wait(hgrant ==4'b0000);
				for(i=0;i<=1;i=i+1)
					begin
#10						htrans[1:0]=2'b01;hburst[2:0]=3'b010;hlock_main[1]=1;busreq[1]=1'b1;data_in[15:8]=data_in[15:8]+1;
					end

#10		htrans[1:0]=2'b01;hburst[2:0]=3'b000;hlock_main[1]=0;busreq[1]=1'b0;data_in[15:8]=data_in[15:8]+1;

	end
endtask



generic_arbiter_full g1(.busreq(busreq),.hlock(hlock_main),.hclk(clock),.hreset(reset),.hmaster_lock(hmaster_lock),.hgrant(hgrant),.hready(hready),.hwdata(data_in),.data_out(data_out),.haddr(addr_in),.addr_out(addr_out),.htrans(htrans),.hburst(hburst),.htrans_out(htrans_out),.hburst_out(hburst_out),.hmaster(hmaster) );

endmodule

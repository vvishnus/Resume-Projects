//`include "simplified_sha256.sv"

module bitcoin_hash (input logic        clk, reset_n, start,
                     input logic [15:0] header_addr, hash_out_addr,
                    output logic        done, mem_clk, mem_we,
                    output logic [15:0] memory_addr,
                    output logic [31:0] memory_write_data,
                     input logic [31:0] memory_read_data);

parameter num_nonces = 16;

//Declaring the states
enum logic [ 3:0] {IDLE, READ_BUFFER, READ, PHASE1, PHASE2_PREP, PHASE2, PHASE3_PREP, PHASE3, WRITE_BUFFER1, WRITE_BUFFER2, WRITE}state;

logic [31:0] message[32]; //Since it is a 20 word input
logic [31:0] h0[8], h1[8], h2[8], h3[8], h4[8], h5[8], h6[8], h7[8], h8[8], h9[8], h10[8], h11[8], h12[8], h13[8], h14[8], h15[8], h16[8];
logic [31:0] w0[16], w1[16], w2[16], w3[16], w4[16], w5[16], w6[16], w7[16], w8[16], w9[16], w10[16], w11[16], w12[16], w13[16], w14[16], w15[16];
logic start_phase1, start_next_phase;
logic  new_hashes_phase1, new_hashes_phase2;
logic done0, done1, done2, done3, done4, done5, done6, done7, done8, done9, done10, done11, done12, done13, done14, done15, done16;


logic [ 7:0] clock;
logic [ 15:0] offset; 
logic        enable_write;
logic [15:0] present_address;
logic [31:0] present_write_data;

assign mem_clk = clk;
assign memory_addr = present_address + offset;
assign mem_we = enable_write;
assign memory_write_data = present_write_data;

simplified_sha256 inst0 (
	.clk(clk),
	.reset_n(reset_n),
	.start(start_phase1),
	.message(w0),
	.in(h0),
	.new_hashes(new_hashes_phase1),
	.done(done0),
	.sha(h0)
	);

	simplified_sha256 inst1 (
	.clk(clk),
	.reset_n(reset_n),
	.start(start_next_phase),
	.message(w0),
	.in(h0),
	.new_hashes(new_hashes_phase2),
	.done(done1),
	.sha(h1)
	);
	
	simplified_sha256 inst2 (
	.clk(clk),
	.reset_n(reset_n),
	.start(start_next_phase),
	.message(w1),
	.in(h0),
	.new_hashes(new_hashes_phase2),
	.done(done2),
	.sha(h2)
	);
	
	simplified_sha256 inst3 (
	.clk(clk),
	.reset_n(reset_n),
	.start(start_next_phase),
	.message(w2),
	.in(h0),
	.new_hashes(new_hashes_phase2),
	.done(done3),
	.sha(h3)
	);
	
	simplified_sha256 inst4 (
	.clk(clk),
	.reset_n(reset_n),
	.start(start_next_phase),
	.message(w3),
	.in(h0),
	.new_hashes(new_hashes_phase2),
	.done(done4),
	.sha(h4)
	);
	
	
	
	simplified_sha256 inst5 (
	.clk(clk),
	.reset_n(reset_n),
	.start(start_next_phase),
	.message(w4),
	.in(h0),
	.new_hashes(new_hashes_phase2),
	.done(done5),
	.sha(h5)
	);
	
	simplified_sha256 inst6 (
	.clk(clk),
	.reset_n(reset_n),
	.start(start_next_phase),
	.message(w5),
	.in(h0),
	.new_hashes(new_hashes_phase2),
	.done(done6),
	.sha(h6)
	);
	
	simplified_sha256 inst7 (
	.clk(clk),
	.reset_n(reset_n),
	.start(start_next_phase),
	.message(w6),
	.in(h0),
	.new_hashes(new_hashes_phase2),
	.done(done7),
	.sha(h7)
	);
	
	simplified_sha256 inst8 (
	.clk(clk),
	.reset_n(reset_n),
	.start(start_next_phase),
	.message(w7),
	.in(h0),
	.new_hashes(new_hashes_phase2),
	.done(done8),
	.sha(h8)
	);
	
	simplified_sha256 inst9 (
	.clk(clk),
	.reset_n(reset_n),
	.start(start_next_phase),
	.message(w8),
	.in(h0),
	.new_hashes(new_hashes_phase2),
	.done(done9),
	.sha(h9)
	);
	
	simplified_sha256 inst10 (
	.clk(clk),
	.reset_n(reset_n),
	.start(start_next_phase),
	.message(w9),
	.in(h0),
	.new_hashes(new_hashes_phase2),
	.done(done10),
	.sha(h10)
	);
	
	simplified_sha256 inst11 (
	.clk(clk),
	.reset_n(reset_n),
	.start(start_next_phase),
	.message(w10),
	.in(h0),
	.new_hashes(new_hashes_phase2),
	.done(done11),
	.sha(h11)
	);
	
	simplified_sha256 inst12 (
	.clk(clk),
	.reset_n(reset_n),
	.start(start_next_phase),
	.message(w11),
	.in(h0),
	.new_hashes(new_hashes_phase2),
	.done(done12),
	.sha(h12)
	);
	
	simplified_sha256 inst13 (
	.clk(clk),
	.reset_n(reset_n),
	.start(start_next_phase),
	.message(w12),
	.in(h0),
	.new_hashes(new_hashes_phase2),
	.done(done13),
	.sha(h13)
	);
	
	simplified_sha256 inst14 (
	.clk(clk),
	.reset_n(reset_n),
	.start(start_next_phase),
	.message(w13),
	.in(h0),
	.new_hashes(new_hashes_phase2),
	.done(done14),
	.sha(h14)
	);
	
	simplified_sha256 inst15 (
	.clk(clk),
	.reset_n(reset_n),
	.start(start_next_phase),
	.message(w14),
	.in(h0),
	.new_hashes(new_hashes_phase2),
	.done(done15),
	.sha(h15)
	);
	
	simplified_sha256 inst16 (
	.clk(clk),
	.reset_n(reset_n),
	.start(start_next_phase),
	.message(w15),
	.in(h0),
	.new_hashes(new_hashes_phase2),
	.done(done16),
	.sha(h16)
	);
	
	
//Fully parallel Implementation
always_ff @(posedge clk, negedge reset_n)
begin
  if (!reset_n) begin
    enable_write <= 1'b0;
    state <= IDLE;
  end 
  else case (state)
  
   IDLE: begin 
       if(start) begin
			present_address <= header_addr;
			enable_write <= 1'b0;
			offset <= 16'b0;
			clock <= 8'b0;
			start_phase1 <= 0;	
			start_next_phase <= 0;	
			state <= READ_BUFFER;
       end
    end

	 READ_BUFFER:begin
		state <= READ;
    end 
	 
	  READ: begin
			
			//First 20 words as they are
			if(offset < 19) 
				begin
					message[offset] <= memory_read_data;
					offset <= offset + 1;
					state <= READ_BUFFER;
				end
			else begin
			
				//Padding the message
				message[20] <= 32'h80000000;
				message[31] <= 32'd640;
				for(int n = 21; n<31; n++) message[n] <= 32'h0;
				offset <= 0;
				
				//For 1st Phase the 512 bit w value is the first 512 bits of the message
				for(int n=0; n<16; n++) w0[n] <= message[n];
				state <=PHASE1;	
			end
		end			
		
	 //Passing the first w block into sha256 instance to get new hashes
    PHASE1: begin
	 
				start_phase1 <= 1;
				
				//We use the standard hashes for the first phase
				new_hashes_phase1 <= 0;
				clock <= clock + 1;
				state <= PHASE2_PREP;
    end

	 PHASE2_PREP: begin
	 
		//wait a few clock cycles
		if(clock < 3) begin
			clock <= clock + 1;
			state <= PHASE2_PREP;
		end
		else begin
		start_phase1 <= 0;
		
		//Begin creating w for phase2 onece phase 1 is completed and new hashes are created
		if(done0) begin
			clock <= 0;
			
			//For phase 2 the first 3 w[] are last 3 words of input message
			for(int n=0;n<3;n++) w0[n] <= message[n+16];
			for(int n=0;n<3;n++) w1[n] <= message[n+16];
			for(int n=0;n<3;n++) w2[n] <= message[n+16];
			for(int n=0;n<3;n++) w3[n] <= message[n+16];
			for(int n=0;n<3;n++) w4[n] <= message[n+16];
			for(int n=0;n<3;n++) w5[n] <= message[n+16];
			for(int n=0;n<3;n++) w6[n] <= message[n+16];
			for(int n=0;n<3;n++) w7[n] <= message[n+16];
			for(int n=0;n<3;n++) w8[n] <= message[n+16];
			for(int n=0;n<3;n++) w9[n] <= message[n+16];
			for(int n=0;n<3;n++) w10[n] <= message[n+16];
			for(int n=0;n<3;n++) w11[n] <= message[n+16];
			for(int n=0;n<3;n++) w12[n] <= message[n+16];
			for(int n=0;n<3;n++) w13[n] <= message[n+16];
			for(int n=0;n<3;n++) w14[n] <= message[n+16];
			for(int n=0;n<3;n++) w15[n] <= message[n+16];
			
			//wi[3] are the nonces iterating from 0 to 15
			w0[3] <= 32'd0;
			w1[3] <= 32'd1;
			w2[3] <= 32'd2;
			w3[3] <= 32'd3;
			w4[3] <= 32'd4;
			w5[3] <= 32'd5;
			w6[3] <= 32'd6;
			w7[3] <= 32'd7;
			w8[3] <= 32'd8;
			w9[3] <= 32'd9;
			w10[3] <= 32'd10;
			w11[3] <= 32'd11;
			w12[3] <= 32'd12;
			w13[3] <= 32'd13;
			w14[3] <= 32'd14;
			w15[3] <= 32'd15;
			
			//The rest of the w consist of 10 h'0 and the length of message
			//The remaining length of the padded message from message[20] to message[31] contain this information
			for(int n=4;n<16;n++) w0[n] <= message[n+16];
			for(int n=4;n<16;n++) w1[n] <= message[n+16];
			for(int n=4;n<16;n++) w2[n] <= message[n+16];
			for(int n=4;n<16;n++) w3[n] <= message[n+16];
			for(int n=4;n<16;n++) w4[n] <= message[n+16];
			for(int n=4;n<16;n++) w5[n] <= message[n+16];
			for(int n=4;n<16;n++) w6[n] <= message[n+16];
			for(int n=4;n<16;n++) w7[n] <= message[n+16];
			for(int n=4;n<16;n++) w8[n] <= message[n+16];
			for(int n=4;n<16;n++) w9[n] <= message[n+16];
			for(int n=4;n<16;n++) w10[n] <= message[n+16];
			for(int n=4;n<16;n++) w11[n] <= message[n+16];
			for(int n=4;n<16;n++) w12[n] <= message[n+16];
			for(int n=4;n<16;n++) w13[n] <= message[n+16];
			for(int n=4;n<16;n++) w14[n] <= message[n+16];
			for(int n=4;n<16;n++) w15[n] <= message[n+16];
			state <= PHASE2;
		end
		else begin
			
			//If our phase 1 is not done yet
			state <= PHASE2_PREP;
		end
		end
	end
	
	PHASE2: begin
			start_next_phase <= 1;
			
			//We need to use the new hashes outputed from phase one in phase 2
			new_hashes_phase2 <= 1;
			clock <= clock + 1;
			state <= PHASE3_PREP;
    end

	 //Brgin preparing w for phase 3
	 PHASE3_PREP: begin
		if(clock < 5) begin
			clock <= clock + 1;
			state <= PHASE3_PREP;
		end
		else begin
		
		//Once phase 2 is complete, we disable the sha256 instances
		start_next_phase <= 0;
		
		//Begin prep only when second phase throws up a done = 1
		if(done1) begin
			clock <= 0;
			
			//First 8 w's are the new hashes that were outputted from our parallel 
			//sha instances from phase 2
			for(int n=0;n<8;n++) w0[n] <= h1[n];
			for(int n=0;n<8;n++) w1[n] <= h2[n];
			for(int n=0;n<8;n++) w2[n] <= h3[n];
			for(int n=0;n<8;n++) w3[n] <= h4[n];
			for(int n=0;n<8;n++) w4[n] <= h5[n];
			for(int n=0;n<8;n++) w5[n] <= h6[n];
			for(int n=0;n<8;n++) w6[n] <= h7[n];
			for(int n=0;n<8;n++) w7[n] <= h8[n];
			for(int n=0;n<8;n++) w8[n] <= h9[n];
			for(int n=0;n<8;n++) w9[n] <= h10[n];
			for(int n=0;n<8;n++) w10[n] <= h11[n];
			for(int n=0;n<8;n++) w11[n] <= h12[n];
			for(int n=0;n<8;n++) w12[n] <= h13[n];
			for(int n=0;n<8;n++) w13[n] <= h14[n];
			for(int n=0;n<8;n++) w14[n] <= h15[n];
			for(int n=0;n<8;n++) w15[n] <= h16[n];
			
			//wi[8] has to have msb of 1
			w0[8] <= 32'h80000000;
			w1[8] <= 32'h80000000;
			w2[8] <= 32'h80000000;
			w3[8] <= 32'h80000000;
			w4[8] <= 32'h80000000;
			w5[8] <= 32'h80000000;
			w6[8] <= 32'h80000000;
			w7[8] <= 32'h80000000;
			w8[8] <= 32'h80000000;
			w9[8] <= 32'h80000000;
			w10[8] <= 32'h80000000;
			w11[8] <= 32'h80000000;
			w12[8] <= 32'h80000000;
			w13[8] <= 32'h80000000;
			w14[8] <= 32'h80000000;
			w15[8] <= 32'h80000000;
			
			//wi[9] to wi[14] are padded with 0's
			for(int n=9; n<15; n++) 
			begin
				w0[n] <= 32'h0;
				w1[n] <= 32'h0;
				w2[n] <= 32'h0;
				w3[n] <= 32'h0;
				w4[n] <= 32'h0;
				w5[n] <= 32'h0;
				w6[n] <= 32'h0;
				w7[n] <= 32'h0;
				w8[n] <= 32'h0;
				w9[n] <= 32'h0;
				w10[n] <= 32'h0;
				w11[n] <= 32'h0;
				w12[n] <= 32'h0;
				w13[n] <= 32'h0;
				w14[n] <= 32'h0;
				w15[n] <= 32'h0;
			end
			
			//Last w bit contains 32 bit representation of 256 - i.e the length of our new message
			w0[15] <= 32'd256;
			w1[15] <= 32'd256;
			w2[15] <= 32'd256;
			w3[15] <= 32'd256;
			w4[15] <= 32'd256;
			w5[15] <= 32'd256;
			w6[15] <= 32'd256;
			w7[15] <= 32'd256;
			w8[15] <= 32'd256;
			w9[15] <= 32'd256;
			w10[15] <= 32'd256;
			w11[15] <= 32'd256;
			w12[15] <= 32'd256;
			w13[15] <= 32'd256;
			w14[15] <= 32'd256;
			w15[15] <= 32'd256;
			
			//Go onto phase 3
			state <= PHASE3;
		end
		else begin
		
			//Keep coming to phase3 prep if phase 2 is not yet complete
			state <= PHASE3_PREP;
		end
		end
	end
	
	//Begin parallel computation of phase3
	PHASE3: begin
			start_next_phase <= 1;
			new_hashes_phase2 <= 0;
			clock <= clock + 1;
			state <= WRITE_BUFFER1;
    end

	 //Buffer to prepare for writing the data
	 WRITE_BUFFER1: begin
		if(clock < 5) begin
			clock <= clock + 1;
			state <= WRITE_BUFFER1;
		end
		else begin
		
		//disable the sha256 instances
		start_next_phase <= 0;
		
		//Making sure phase 3 calculations are complete
		if(done1) begin
			clock <= 0;
			present_address <= hash_out_addr;
			enable_write <= 1'b1;
			state <= WRITE_BUFFER2;
		end
		else begin
			state <= WRITE_BUFFER1;
		end
		end
	end
	
	   //Buffer in order to enable write and avoid effect of clock cycle on writing to memory 
		WRITE_BUFFER2:
		begin
		
		//FIRST HASH
		present_write_data <= h1[0];
		state <= WRITE;
	 end

		
	 WRITE: 
	 begin
		if(offset < 16)
		begin
		
		//Writing the data
		case(offset)
			    0: present_write_data <= h2[0];
			    1: present_write_data <= h3[0];
			    2: present_write_data <= h4[0];
			    3: present_write_data <= h5[0];
			    4: present_write_data <= h6[0];
			    5: present_write_data <= h7[0];
			    6: present_write_data <= h8[0];
			    7: present_write_data <= h9[0];
				 8: present_write_data <= h10[0];
			    9: present_write_data <= h11[0];
			    10: present_write_data <= h12[0];
			    11: present_write_data <= h13[0];
			    12: present_write_data <= h14[0];
			    13: present_write_data <= h15[0];
			    14: present_write_data <= h16[0];
			    15: present_write_data <= h16[0];
			    default: present_write_data <= h2[0];
				 
		  endcase
			offset <= offset + 1;
			state <= WRITE;

		end
		else begin
		state <= IDLE;
		end
    end
   endcase
  end
	
assign done = (state == IDLE);	

endmodule
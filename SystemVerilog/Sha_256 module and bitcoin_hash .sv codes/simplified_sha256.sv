
module simplified_sha256 #(parameter integer NUM_OF_WORDS = 16)(
 input logic  clk, reset_n, start, new_hashes,
 input logic [31:0] message[16],
 input logic [31:0] in[8],
 output logic [31:0] sha[8],
 output logic done);
 
// FSM state variables 
enum logic [2:0] {IDLE, BLOCK, COMPUTE, WRITE, COMPLETE} state;


// NOTE : Below mentioned frame work is for reference purpose.
// Local variables might not be complete and you might have to add more variables
// or modify these variables. Code below is more as a reference.

// Local variables
logic [31:0] w[64];
logic [31:0] S0,S1;
logic [31:0] h0, h1, h2, h3, h4, h5, h6, h7;
logic [31:0] a, b, c, d, e, f, g, h;
logic [ 7:0] i, j, t;





// SHA256 K constants
parameter int k[0:63] = '{
   32'h428a2f98,32'h71374491,32'hb5c0fbcf,32'he9b5dba5,32'h3956c25b,32'h59f111f1,32'h923f82a4,32'hab1c5ed5,
   32'hd807aa98,32'h12835b01,32'h243185be,32'h550c7dc3,32'h72be5d74,32'h80deb1fe,32'h9bdc06a7,32'hc19bf174,
   32'he49b69c1,32'hefbe4786,32'h0fc19dc6,32'h240ca1cc,32'h2de92c6f,32'h4a7484aa,32'h5cb0a9dc,32'h76f988da,
   32'h983e5152,32'ha831c66d,32'hb00327c8,32'hbf597fc7,32'hc6e00bf3,32'hd5a79147,32'h06ca6351,32'h14292967,
   32'h27b70a85,32'h2e1b2138,32'h4d2c6dfc,32'h53380d13,32'h650a7354,32'h766a0abb,32'h81c2c92e,32'h92722c85,
   32'ha2bfe8a1,32'ha81a664b,32'hc24b8b70,32'hc76c51a3,32'hd192e819,32'hd6990624,32'hf40e3585,32'h106aa070,
   32'h19a4c116,32'h1e376c08,32'h2748774c,32'h34b0bcb5,32'h391c0cb3,32'h4ed8aa4a,32'h5b9cca4f,32'h682e6ff3,
   32'h748f82ee,32'h78a5636f,32'h84c87814,32'h8cc70208,32'h90befffa,32'ha4506ceb,32'hbef9a3f7,32'hc67178f2
};




// SHA256 hash round
function logic [255:0] sha256_op(input logic [31:0] a, b, c, d, e, f, g, h, w,
                                 input logic [7:0] t);
    logic [31:0] S1, S0, ch, maj, t1, t2; // internal signals	 
begin

	S1 = ror(e, 6) ^ ror(e, 11) ^ ror(e, 25);
	ch = (e & f) ^ ((~e) & g);

	// Boolean function of e, f, and g

	t1 = h+S1+ch+k[t]+w;

	// function of h, w, ch, k[t], and S1
	S0 = ror(a, 2) ^ ror(a, 13) ^ ror(a, 22); 
	maj = (a & b) ^ (a & c) ^ (b & c);
	// carry bit of a, b, and c -- majority gate
	t2 = S0 + maj;

	// function of maj and S0

	sha256_op = {t1 + t2, a, b, c, d + t1, e, f, g};
  
end
endfunction

//Word expansion function for calculating w[15]
function logic [31:0] word_expand;
	// Internal variables
	logic [31:0] S1, S0;
	begin
		S0 = ror(w[1], 7) ^ ror(w[1], 18) ^ (w[1] >> 3);
		S1 = ror(w[14], 17) ^ ror(w[14], 19) ^ (w[14] >> 10);
		word_expand = w[0] + S0 + w[9] + S1;
	end
endfunction	

// Right Rotation Example : right rotate input x by r
// Lets say input x = 1111 ffff 2222 3333 4444 6666 7777 8888
// lets say r = 4
// x >> r  will result in : 0000 1111 ffff 2222 3333 4444 6666 7777 
// x << (32-r) will result in : 8888 0000 0000 0000 0000 0000 0000 0000
// final right rotate expression is = (x >> r) | (x << (32-r));
// (0000 1111 ffff 2222 3333 4444 6666 7777) | (8888 0000 0000 0000 0000 0000 0000 0000)
// final value after right rotate = 8888 1111 ffff 2222 3333 4444 6666 7777
// Right rotation function

function logic [31:0] ror(input logic [31:0] x,
                                  input logic [7:0] r);
begin
	ror = (x >> r) | (x << (32-r));
end
endfunction




// SHA-256 FSM 
// Get a BLOCK from the memory, COMPUTE Hash output using SHA256 function
// and write back hash value back to memory

always_ff @(posedge clk, negedge reset_n)
begin
  if (!reset_n) begin
    state <= IDLE;
  end
  else 
  begin
  case (state)
		
		IDLE: begin 
		if(start) begin
	
			if(!new_hashes)
			begin
			// Initialize hash values h0 to h7 and a to h, other variables and memory we, address offset, etc
			h0 <= 32'h6a09e667;
			h1 <= 32'hbb67ae85;
			h2 <= 32'h3c6ef372;
			h3 <= 32'ha54ff53a;
			h4 <= 32'h510e527f;
			h5 <= 32'h9b05688c;
			h6 <= 32'h1f83d9ab;
			h7 <= 32'h5be0cd19;
		
			a <= 32'h6a09e667;
			b <= 32'hbb67ae85;
			c <= 32'h3c6ef372;
			d <= 32'ha54ff53a;
			e <= 32'h510e527f;
			f <= 32'h9b05688c;
			g <= 32'h1f83d9ab;
			h <= 32'h5be0cd19;
			end
			
			else begin
			h0 <= in[0];
			h1 <= in[1];
			h2 <= in[2];
			h3 <= in[3];
			h4 <= in[4];
			h5 <= in[5];
			h6 <= in[6];
			h7 <= in[7];
		
			a <= in[0];
			b <= in[1];
			c <= in[2];
			d <= in[3];
			e <= in[4];
			f <= in[5];
			g <= in[6];
			h <= in[7];
			end
			
		i <= 8'b0;
		j <= 8'b0;
		t <= 8'b0;
      state <= BLOCK;
		   end
		end
		

		
		
		// SHA-256 FSM 
		// Get a BLOCK from the memory, COMPUTE Hash output using SHA256 function    
		// and write back hash value back to memory
		BLOCK: begin
		// Fetch message in 512-bit block size
		// For each of 512-bit block initiate hash value computation
		
				
					//First 16 words
					for(int q=0; q<16; q++)
						begin
						   // first 16 words of word expansion of each block gets the original message
							w[q] <= message[q]; 
						end
					
					state <= COMPUTE;
				end
			

		
		// For each block compute hash function
		// Go back to BLOCK stage after each block hash computation is completed and if
		// there are still number of message blocks available in memory otherwise
		// move to WRITE stage
		COMPUTE: 
		begin
		// 64 processing rounds steps for 512-bit block 
		
		//We will implement the improved algorithm for w. 
		//w is left shifted one bit and w[15] is found by word expansion
			if(i<64) 
				begin
					{a, b, c, d, e, f, g, h} <= sha256_op(a,b,c,d,e,f,g,h,w[0],i);
					
					//left shift from w[0] to w[14]
					for(int q=0; q<15; q++)
						begin
							w[q] <= w[q+1];
						end
					
					//w[15] is calculated by word expansion	
               w[15] <= word_expand;
					
					// Update iteration variable i
					i <= i + 1;
					state <= COMPUTE;
				end
			
			//assignments of new hash once the 64 iterations of each block are complete
			else 
				begin
				
				   //reset iteration variable i after it reaches 64
					i <= 8'b0;
					
					// Update our h's and variables in the same clock cycle
					h0 <= a + h0;
					h1 <= b + h1;
					h2 <= c + h2;
					h3 <= d + h3;
					h4 <= e + h4;
					h5 <= f + h5;
					h6 <= g + h6;
					h7 <= h + h7;
					
					// Update our h's and variables in the same clock cycle
					a <= a + h0;
					b <= b + h1;
					c <= c + h2;
					d <= d + h3;
					e <= e + h4;
					f <= f + h5;
					g <= g + h6;
					h <= h + h7;
					state <= WRITE;
				end
			end
		
		// h0 to h7 each are 32 bit hashes, which makes up total 256 bit value
		// h0 to h7 after compute stage has final computed hash value
		// write back these h0 to h7 to memory starting from output_addr
		WRITE: begin
		
		sha[0] <= h0;
		sha[1] <= h1;
		sha[2] <= h2;
		sha[3] <= h3;
		sha[4] <= h4;
		sha[5] <= h5;
		sha[6] <= h6;
		sha[7] <= h7;
		
		state <= COMPLETE;
		
		end
		
		COMPLETE:
		begin
		
		 state <= IDLE;
		 
		 end
	 
  endcase
end
end

// Generate done when SHA256 hash computation has finished and moved to IDLE state
assign done = (state == IDLE);

endmodule



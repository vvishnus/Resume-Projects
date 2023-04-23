module simplified_sha256 #(parameter integer NUM_OF_WORDS = 20)(
 input logic  clk, rst_n, start,
 input logic  [15:0] input_addr, hash_addr,
 output logic done, memory_clk, memory_we,
 output logic [15:0] memory_addr,
 output logic [31:0] memory_write_data,
 input logic [31:0] memory_read_data);

// FSM state variables 
enum logic [2:0] {IDLE, READ_BUFFER, READ_MSG, BLOCK, COMPUTE, WRITE_BUFFER, WRITE} state;

parameter integer SIZE = NUM_OF_WORDS * 32; 
parameter integer blocks = ((NUM_OF_WORDS+2)/16) + 1;
// NOTE : Below mentioned frame work is for reference purpose.
// Local variables might not be complete and you might have to add more variables
// or modify these variables. Code below is more as a reference.

// Local variables
logic [31:0] w[64];
logic [31:0] message[64]; // since we hardcoded our number of words to 40, we have message of 48 * 32 bits
logic [31:0] wt;
logic [31:0] S0,S1;
logic [31:0] h0, h1, h2, h3, h4, h5, h6, h7;
logic [31:0] a, b, c, d, e, f, g, h;
logic [ 7:0] i, j, t;
logic [15:0] offset; // in word address
logic [ 7:0] num_blocks;
logic        enable_write;
logic [15:0] present_addr,write_addr;
logic [31:0] present_write_data;
logic [512:0] data_read;
logic [ 7:0] tstep;




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


// Generate request to memory
// for reading from memory to get original message
// for writing final computed has value
assign memory_clk = clk;
assign memory_addr = present_addr + offset;
assign memory_we = enable_write;
assign memory_write_data = present_write_data;


assign num_blocks = determine_num_blocks(NUM_OF_WORDS); 
assign tstep = (i - 1);

// Note : Function defined are for reference purpose. Feel free to add more functions or modify below.
// Function to determine number of blocks in memory to fetch
function logic [15:0] determine_num_blocks(input logic [31:0] size);

begin
  determine_num_blocks = ((NUM_OF_WORDS+2)/16) + 1;

 end
endfunction


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


// final value after right rotate = 8888 1111 ffff 2222 3333 4444 6666 7777
// Right rotation function

function logic [31:0] ror(input logic [31:0] in,
                                  input logic [7:0] s);
begin
	ror = (in >> s) | (in << (32-s));
end
endfunction




// SHA-256 FSM 
// Get a BLOCK from the memory, COMPUTE Hash output using SHA256 function
// and write back hash value back to memory

always_ff @(posedge clk, negedge rst_n)
begin
  if (!rst_n) begin
    state <= IDLE;
    enable_write <= 1'b0;
  end
  else begin 
	  case (state)
		
		IDLE: begin 
			if(start) begin 
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

		// Block counter variable
		j<= 0;
		i<= 0;
		//memory address cursor
		offset<= 0;
		// set memory to read 
		enable_write <= 0 ;
		// get staring address 
		present_addr <= input_addr;
		t <= 0;
		// moving to STORE_MSG
		state <=  READ_BUFFER;

		   end
		end
		
		
		
		//Buffer state to reduce address fetch errors
      READ_BUFFER: begin
		
			state <= READ_MSG;
		end
		
		
		
		//Read the message and pad if necessary
		READ_MSG: begin
		
		//store the first 40 words as they are
		if(offset < NUM_OF_WORDS) 
				begin
					message[offset] <= memory_read_data;
					offset <= offset + 1;
					state <= READ_BUFFER;
				end
		//pad the last 512 bit block
		else	
			begin
			
				offset <= 16'b0;
				// l+1 bit gets 1 as the most significant bit
				message[NUM_OF_WORDS] <= 32'h80000000; 
				
				//add 0's until the last word of message
				for(int q = NUM_OF_WORDS+1 ; q < (blocks*16 -1); q++)
					begin
							message[q] <= 32'h0;
					end
				
				// last word gets the length of the original message = 40*32 bits = 1280
				message[blocks*16 -1] <= SIZE; 
				
				// we move to the block state
				state <=BLOCK;	
			end
			
		end
		
		
		
		
		// SHA-256 FSM 
		// Get a BLOCK from the memory, COMPUTE Hash output using SHA256 function    
		// and write back hash value back to memory
		BLOCK: begin
		// Fetch message in 512-bit block size
		// For each of 512-bit block initiate hash value computation
		
		
			if(j < num_blocks) 
				begin
				
					//First 16 words
					for(int q=0; q<16; q++)
						begin
						   // first 16 words of word expansion of each block gets the original message
							w[q] <= message[q + (j*16)]; 
						end
						
					j <= j + 1;					
					//We move to the computation stage of each block
					state <= COMPUTE;
				end
			else 
				begin
					state <= WRITE_BUFFER;
				end
			

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
					state <= BLOCK;
				end
					
		end
		
		
		//Buffer in order to enable write and avoid effect of clock cycle on writing to memory 
		WRITE_BUFFER:begin
		
		   //enabling write
			enable_write <= 1'b1;
			
			//We update address to address we want to write to
			present_addr <= hash_addr;
			present_write_data <= h0;
         // go the WRITE state
			state <= WRITE;
			
	 end
	 

		
		// h0 to h7 each are 32 bit hashes, which makes up total 256 bit value
		// h0 to h7 after compute stage has final computed hash value
		// write back these h0 to h7 to memory starting from output_addr
		WRITE: begin
		
		//Writing the final 256 bit output
		//Cannot use for loop as it will write in same clock cycle
		case(offset + 1)
			//0: present_write_data <= h0;
			1: present_write_data <= h1;
			2: present_write_data <= h2;
			3: present_write_data <= h3;
			4: present_write_data <= h4;
			5: present_write_data <= h5;
			6: present_write_data <= h6;
			7: present_write_data <= h7;
			endcase
			
			offset <= offset + 1;
			
		if(offset < 8)
		begin
		 state <= WRITE;
		end
			
		else begin
		state <= IDLE;
		end
	end
   endcase
	end
end

// Generate done when SHA256 hash computation has finished and moved to IDLE state
assign done = (state == IDLE);

endmodule

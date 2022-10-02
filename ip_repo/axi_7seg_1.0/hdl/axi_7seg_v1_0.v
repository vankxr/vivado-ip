
`timescale 1 ns / 1 ps

	module axi_7seg_v1_0 #
	(
		// Users to add parameters here

		// User parameters ends
		// Do not modify the parameters beyond this line


		// Parameters of Axi Slave Bus Interface AXI
		parameter integer C_AXI_DATA_WIDTH	= 32,
		parameter integer C_AXI_ADDR_WIDTH	= 4
	)
	(
		// Users to add ports here

		// User ports ends
		// Do not modify the ports beyond this line


		// Ports of Axi Slave Bus Interface AXI
		input wire  axi_aclk,
		input wire  axi_aresetn,
		input wire [C_AXI_ADDR_WIDTH-1 : 0] axi_awaddr,
		input wire [2 : 0] axi_awprot,
		input wire  axi_awvalid,
		output wire  axi_awready,
		input wire [C_AXI_DATA_WIDTH-1 : 0] axi_wdata,
		input wire [(C_AXI_DATA_WIDTH/8)-1 : 0] axi_wstrb,
		input wire  axi_wvalid,
		output wire  axi_wready,
		output wire [1 : 0] axi_bresp,
		output wire  axi_bvalid,
		input wire  axi_bready,
		input wire [C_AXI_ADDR_WIDTH-1 : 0] axi_araddr,
		input wire [2 : 0] axi_arprot,
		input wire  axi_arvalid,
		output wire  axi_arready,
		output wire [C_AXI_DATA_WIDTH-1 : 0] axi_rdata,
		output wire [1 : 0] axi_rresp,
		output wire  axi_rvalid,
		input wire  axi_rready,
		// 7 Segment interface
		output [3:0] sseg_an,
		output [7:0] sseg
	);
	
	wire [31:0] clk_div;
	wire [3:0] char0;
	wire [3:0] char1;
	wire [3:0] char2;
	wire [3:0] char3;
	
// Instantiation of Axi Bus Interface AXI
	axi_7seg_v1_0_AXI # ( 
		.C_S_AXI_DATA_WIDTH(C_AXI_DATA_WIDTH),
		.C_S_AXI_ADDR_WIDTH(C_AXI_ADDR_WIDTH)
	) axi_7seg_v1_0_AXI_inst (
		.S_AXI_ACLK(axi_aclk),
		.S_AXI_ARESETN(axi_aresetn),
		.S_AXI_AWADDR(axi_awaddr),
		.S_AXI_AWPROT(axi_awprot),
		.S_AXI_AWVALID(axi_awvalid),
		.S_AXI_AWREADY(axi_awready),
		.S_AXI_WDATA(axi_wdata),
		.S_AXI_WSTRB(axi_wstrb),
		.S_AXI_WVALID(axi_wvalid),
		.S_AXI_WREADY(axi_wready),
		.S_AXI_BRESP(axi_bresp),
		.S_AXI_BVALID(axi_bvalid),
		.S_AXI_BREADY(axi_bready),
		.S_AXI_ARADDR(axi_araddr),
		.S_AXI_ARPROT(axi_arprot),
		.S_AXI_ARVALID(axi_arvalid),
		.S_AXI_ARREADY(axi_arready),
		.S_AXI_RDATA(axi_rdata),
		.S_AXI_RRESP(axi_rresp),
		.S_AXI_RVALID(axi_rvalid),
		.S_AXI_RREADY(axi_rready),
		.clk_div(clk_div),
		.char0(char0),
		.char1(char1),
		.char2(char2),
		.char3(char3)
	);

    reg [31:0] cnt;
    reg [1:0] an;
    
    always @(posedge axi_aclk)
        begin
            if(axi_aresetn == 1'b0)
                begin
                    cnt <= 32'h00000000;
                    an <= 2'b00;
                end 
        else
            begin
                if(clk_div > 32'h00000000)
                    begin
                        if(cnt == clk_div)
                            begin
                                cnt <= 32'h00000000;
                                an <= an + 1;
                            end
                        else
                            begin
                                cnt <= cnt + 1;
                            end
                        end
                    else
                        begin
                            cnt <= 32'h00000000;
                        end
            end
    end

	reg [3:0] char;
	reg [3:0] sseg_an;
	
    always @(*)
        begin
            case(an)
                4'd0:
                    begin
                        sseg_an <= 4'b1110;
                        char <= char0;
                    end
                4'd1:
                    begin
                        sseg_an <= 4'b1101;
                        char <= char1;
                    end
                4'd2:
                    begin
                        sseg_an <= 4'b1011;
                        char <= char2;
                    end
                4'd3:
                    begin
                        sseg_an <= 4'b0111;
                        char <= char3;
                    end
            endcase
        end
	
	reg [7:0] sseg_dec;
	
	always @(*)
        begin
            case(char)
                4'h0: sseg_dec <= 8'b11000000;
                4'h1: sseg_dec <= 8'b11111001;
                4'h2: sseg_dec <= 8'b10100100;
                4'h3: sseg_dec <= 8'b10110000;
                4'h4: sseg_dec <= 8'b10011001;
                4'h5: sseg_dec <= 8'b10010010;
                4'h6: sseg_dec <= 8'b10000010;
                4'h7: sseg_dec <= 8'b11111000;
                4'h8: sseg_dec <= 8'b10000000;
                4'h9: sseg_dec <= 8'b10010000;
                4'hA: sseg_dec <= 8'b10001000;
                4'hB: sseg_dec <= 8'b10000011;
                4'hC: sseg_dec <= 8'b11000110;
                4'hD: sseg_dec <= 8'b10100001;
                4'hE: sseg_dec <= 8'b10000110;
                4'hF: sseg_dec <= 8'b10001110;
            endcase
        end
	
	wire [7:0] sseg;
	
	assign sseg = axi_aresetn ? sseg_dec : 8'hFF;

	endmodule

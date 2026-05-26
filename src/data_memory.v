`timescale 1ns / 1ps

module data_memory(
    input clk,
    input w_en,

    input [2:0] funct3,

    input [31:0] addr,
    input [31:0] data_in,

    output reg [31:0] data_out
);

reg [31:0] mem [63:0];

always @(*) begin

    case(funct3)

        3'b000: begin // LB

            case(addr[1:0])

                2'b00: data_out = {{24{mem[addr[31:2]][7]}},  mem[addr[31:2]][7:0]};
                2'b01: data_out = {{24{mem[addr[31:2]][15]}}, mem[addr[31:2]][15:8]};
                2'b10: data_out = {{24{mem[addr[31:2]][23]}}, mem[addr[31:2]][23:16]};
                2'b11: data_out = {{24{mem[addr[31:2]][31]}}, mem[addr[31:2]][31:24]};

            endcase

        end

        3'b001: begin // LH

            if(addr[1] == 1'b0)
                data_out = {{16{mem[addr[31:2]][15]}}, mem[addr[31:2]][15:0]};
            else
                data_out = {{16{mem[addr[31:2]][31]}}, mem[addr[31:2]][31:16]};

        end

        3'b010: begin // LW

            data_out = mem[addr[31:2]];

        end

        3'b100: begin // LBU

            case(addr[1:0])

                2'b00: data_out = {24'b0, mem[addr[31:2]][7:0]};
                2'b01: data_out = {24'b0, mem[addr[31:2]][15:8]};
                2'b10: data_out = {24'b0, mem[addr[31:2]][23:16]};
                2'b11: data_out = {24'b0, mem[addr[31:2]][31:24]};

            endcase

        end

        3'b101: begin // LHU

            if(addr[1] == 1'b0)
                data_out = {16'b0, mem[addr[31:2]][15:0]};
            else
                data_out = {16'b0, mem[addr[31:2]][31:16]};

        end

        default: begin

            data_out = 32'b0;

        end

    endcase

end

always @(posedge clk) begin

    if(w_en) begin

        case(funct3)

            3'b000: begin // SB

                case(addr[1:0])

                    2'b00: mem[addr[31:2]][7:0]   <= data_in[7:0];
                    2'b01: mem[addr[31:2]][15:8]  <= data_in[7:0];
                    2'b10: mem[addr[31:2]][23:16] <= data_in[7:0];
                    2'b11: mem[addr[31:2]][31:24] <= data_in[7:0];

                endcase

            end

            3'b001: begin // SH

                if(addr[1] == 1'b0)
                    mem[addr[31:2]][15:0] <= data_in[15:0];
                else
                    mem[addr[31:2]][31:16] <= data_in[15:0];

            end

            3'b010: begin // SW

                mem[addr[31:2]] <= data_in;

            end

            default: begin

                mem[addr[31:2]] <= data_in;

            end

        endcase

    end

end

endmodule
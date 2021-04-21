/*
 * File: sim_transducer.sv
 * Project: new
 * Created Date: 11/04/2021
 * Author: Shun Suzuki
 * -----
 * Last Modified: 12/04/2021
 * Modified By: Shun Suzuki (suzuki@hapis.k.u-tokyo.ac.jp)
 * -----
 * Copyright (c) 2021 Hapis Lab. All rights reserved.
 * 
 */

`timescale 1ns / 1ps

module sim_transducer();

localparam int ULTRASOUND_CNT_MAX = 510;

logic MRCC_25P6M;
logic RST;

logic ultrasound_cnt_clk;
logic lpf_clk;
logic [8:0] time_cnt;
logic [7:0] duty;
logic [7:0] phase;
logic silent;
logic pwm_out;

ultrasound_cnt_clk_gen ultrasound_cnt_clk_gen(
                           .clk_in1(MRCC_25P6M),
                           .reset(RST),
                           .clk_out1(ultrasound_cnt_clk),
                           .clk_out2(lpf_clk)
                       );

transducer transducer(
               .CLK(ultrasound_cnt_clk),
               .RST(RST),
               .CLK_LPF(lpf_clk),
               .TIME(time_cnt),
               .DUTY(duty),
               .PHASE(phase),
               .SILENT(silent),
               .PWM_OUT(pwm_out)
           );

initial begin
    MRCC_25P6M = 0;
    RST = 1;
    time_cnt = 0;
    duty = 0;
    phase = 0;
    silent = 1;
    #1000;
    RST = 0;
    #100000;
    duty = 8'd255;
    phase = 8'd127;
    #10000000;
    $finish;
end

always @(posedge ultrasound_cnt_clk) begin
    time_cnt <= (time_cnt == (ULTRASOUND_CNT_MAX-1)) ? 0 : time_cnt + 1;
end

always begin
    #19.531 MRCC_25P6M = !MRCC_25P6M;
    #19.531 MRCC_25P6M = !MRCC_25P6M;
    #19.531 MRCC_25P6M = !MRCC_25P6M;
    #19.532 MRCC_25P6M = !MRCC_25P6M;
end

endmodule
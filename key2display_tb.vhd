-- File: key2display_tb.vhd
-- Author: Karol Kiedrowski
-- Date 2024-04-08
-- Description: Laboratory task module test bench

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use std.env.all;

entity key2display_tb is
    generic(T: time := 1 ns);
end entity key2display_tb;

architecture beh of key2display_tb is
    signal max10_clkl_50 : std_logic;
    signal key : std_logic_vector(1 downto 0);
    signal ledr : std_logic_vector(0 downto 0);
    signal hex5,hex4,hex3,hex2,hex1,hex0 : std_logic_vector(6 downto 0);

    constant PERIOD : delay_length := 20*T;
    procedure clk_gen(signal s: out std_logic; period: delay_length := 10 ns) is
    begin
        loop s <= '0', '1' after period/2;
            wait for period; end loop;
    end procedure;
    procedure pulse (signal s: out std_logic; Hpulse,Lspace: delay_length) is
    begin
            s <= '1', '0' after Hpulse;
            wait for Hpulse + Lspace; 
    end procedure;
    procedure stop_after_falling_edge(signal trig: in std_logic_vector(0 downto 0); delay: delay_length := 0 ns) is
    begin
        if trig(0)='1' then
            wait until trig(0)='0';
            wait until trig(0)='1';
            wait until trig(0)='0';
            wait until trig(0)='0';
            wait until trig(0)='1';
            wait until trig(0)='0';
            wait for delay;
            --report "jestem w procedurze stop" severity Note;
            stop(2);
        end if;
    end procedure;

begin 

    LOL: entity work.key2display
    port map(max10_clkl_50, key, ledr, hex5, hex4, hex3, hex2, hex1, hex0);

    pulse(key(1), 30*PERIOD, 15*PERIOD);
    pulse(key(0), 2*PERIOD, 12*PERIOD);
    clk_gen(max10_clkl_50, PERIOD);
    stop_after_falling_edge(ledr, PERIOD*3);

end architecture beh;
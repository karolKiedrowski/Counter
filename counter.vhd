-- File: counter.vhd
-- Author: Karol Kiedrowski
-- Date 2024-04-09
-- Description: Laboratory task module

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use IEEE.STD_LOGIC_UNSIGNED.all;

entity counter is
    generic (N : natural := 6);
    port 
    (
        clk : in std_logic;
        key : in std_logic_vector(1 downto 0); -- key(0) - rst, ke(1) - ce
        ledr : out std_logic_vector(0 downto 0); -- ceo
        to7dec : out std_logic_vector(4*N-1 downto 0)
    );
    -- clk - clock, czyli sygnal zegara
    -- key(0) - rst, czyli reset
    -- key(1) - ce, czyli counter enable, pozwolenie na zliczanie
    -- ledr - ceo, czyli counter enable output pozwolenie wyjściu na zliczanie
    -- to7dec - wyjscie do licznikow

end entity counter;

architecture count of counter is 
    signal ce_flip : std_logic_vector(N downto 0);
begin 
    ce_flip(0) <= key(1);
    
    ADD_DEC7SEG: for i in 0 to N-1 generate
        seg: entity work.d_cntr4ceo port map
        (
            clk=>clk,
            rst=>key(0),
            ce=>ce_flip(i),
            tc=>open,
            ceo=>ce_flip(i+1),
            q=>to7dec(i*4+3 downto i*4)
        );
    end generate ADD_DEC7SEG;

    -- podstawienie wyjscia z ostatniego segmentu pod sygnal wyjsciowy
    ledr(0) <= ce_flip(N);
end architecture count;

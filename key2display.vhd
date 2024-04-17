-- File: key2display.vhd
-- Author: Karol Kiedrowski
-- Date 2024-04-05
-- Description: Laboratory task module

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity key2display is
    generic (N : natural := 6;
             CLOCK: natural := 1);
    port 
    (
        max10_clk1_50 : in std_logic;
        key : in std_logic_vector(1 downto 0);
        ledr : out std_logic_vector(0 downto 0);
        hex5,hex4,hex3,hex2,hex1,hex0 : out std_logic_vector(6 downto 0)
    );
    -- max10_clkl_50 - sygnal zegara
    -- key(0) - rst, czyli reset licznika
    -- key(1) - ce, czyli counter enable, sygnal, ktory pozwala na zliczanie
    -- ledr - ceo, czyli counter enable output pozwolenie wyjściu na zliczanie (w tym przypadku wchodzi jako sygnal pozwolenia na zliczanie kolejnego elementu przez co jest zliczanie dziesietne)
    -- hex5,hex4,hex3,hex2,hex1,hex0 - wyjscie z modulow, ktore dokonuja konwersji sygnalu na taki, ktory pozwoli wyscietlic odpowiednia liczbe na wyswietlaczu 7 segmentowm
end entity key2display;

architecture keyDisp of key2display is
    
    component counter
        Port (
                clk : in std_logic;
                key : in std_logic_vector(1 downto 0); -- key(0) - rst, ke(1) - ce
                ledr : out std_logic_vector(0 downto 0); -- ceo
                to7dec : out std_logic_vector(4*N-1 downto 0)
            );    
        end component;

    component dec7seg
        Port ( 
                bcd : in std_logic_vector(3 downto 0);
                seg : out std_logic_vector(6 downto 0) 
            );
    end component;

    signal to7dec : std_logic_vector(4*N-1 downto 0);
    signal clock_pass : std_logic_vector(0 downto 0);
    signal clock_key : std_logic_vector(1 downto 0);

begin
    -- opoznienie zagara o dany okres czasu
    clock_key(0) <= '0';
    clock_key(1) <= '1';
    clock_delay : entity work.counter
        generic map(N=>CLOCK)
        port map(clk=>max10_clk1_50, key=>clock_key, ledr=>clock_pass, to7dec=>open);

    -- licznik
    count: entity work.counter 
        generic map (N=>N)
        port map(clk=>clock_pass(0), key=>key, ledr=>ledr, to7dec=>to7dec);

    dec5: dec7seg port map(bcd=>to7dec(23 downto 20), seg=>hex5);
    dec4: dec7seg port map(bcd=>to7dec(19 downto 16), seg=>hex4);
    dec3: dec7seg port map(bcd=>to7dec(15 downto 12), seg=>hex3);
    dec2: dec7seg port map(bcd=>to7dec(11 downto 8), seg=>hex2);
    dec1: dec7seg port map(bcd=>to7dec(7 downto 4), seg=>hex1);
    dec0: dec7seg port map(bcd=>to7dec(3 downto 0), seg=>hex0);

end architecture keyDisp;
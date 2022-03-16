----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 09.03.2022 11:27:06
-- Design Name: 
-- Module Name: MAC - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity MAC is
    port(
        I_clock          : in std_logic;
        I_reset          : in std_logic;
        mult_op1         : in signed(11 downto 0);
        mult_op2         : in signed(11 downto 0);
        I_initSum        : in std_logic;                       -- Control signal to initialize the MAC 
        I_loadSum        : in std_logic;                       -- Control signal to load the MAC register;
        I_loadOut        : in std_logic;
        O_out              : out signed(11 downto 0)           -- filtered sample
    );
end MAC;

architecture Behavioral of MAC is
        signal accumulator : signed(22 downto 0);
begin
        
        process(I_clock, I_reset) is
        begin
            if(I_reset = '1') then
                accumulator <= (others => '0');
            end if;
            if rising_edge(I_clock) then
                if(I_reset = '1') then
                    accumulator <= (others => '0');
                end if;
                if(I_loadSum = '1') then
                    accumulator <= accumulator + mult_op1 * mult_op2;
                end if;
            end if;
        
        end process;
        

end Behavioral;

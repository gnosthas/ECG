----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 09.03.2022 10:42:31
-- Design Name: 
-- Module Name: control_unit - Behavioral
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

entity control_unit is
    port (
    I_clock               : in  std_logic;  -- global clock
    I_reset               : in  std_logic;  -- asynchronous global reset
    I_inputSampleValid    : in  std_logic;  -- Control signal to load the input sample in the sample shift register and shift the register
    I_processingDone      : in  std_logic;
    O_loadShift           : out std_logic;  -- filtered sample
    O_initAddress         : out std_logic;  -- Control signal to initialize register read address
    O_incrAddress         : out std_logic;  -- Control signal to increment register read address
    O_initSum             : out std_logic;  -- Control signal to initialize the MAC register
    O_loadSum             : out std_logic;  -- Control signal to load the MAC register;
    O_loadY               : out std_logic;  -- Control signal to load Y register
    O_FilteredSampleValid : out std_logic  -- Data valid signal for filtered sample                
   );
end entity control_unit;


architecture Behavioral of control_unit is
    
    type T_state is (WAIT_STATE, STORE, 
                      PROCESSING_LOOP1,
                      PROCESSING_LOOP2,
                      PROCESSING_LOOP3,
                      PROCESSING_LOOP4, 
                      OUTPUT); -- List of states
    
      signal SR_presentState : T_state;               -- Signal for the present state (provided by the state register)
      signal SC_futurState   : T_state;       
      
begin
    process (I_clock, I_reset) is
      begin
        if I_reset = '1' then
          SR_presentState <= WAIT_STATE;
        elsif rising_edge(I_clock) then
          SR_presentState <= SC_futurState;
        end if;
      end process;
    
      process (SR_presentState, I_processingDone) is
      begin
        case SR_presentState is
          when WAIT_STATE =>
            SC_futurState <= STORE;
    
        end case;
      end process;
    
     process(SR_presentState)
      begin
        -- Default values
        case SR_presentState is
          when RRCR1_Init =>  __BLANK_TO_FILL__
    
          __BLANK_TO_FILL__
    
        end case;
      end process;
end Behavioral;

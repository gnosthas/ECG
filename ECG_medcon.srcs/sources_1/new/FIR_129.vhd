-------------------------------------------------------------------------------
-- Title      : operativeUnit
-- Project    :
-------------------------------------------------------------------------------
-- File       : operativeUnit.vhd
-- Author     : Jean-Noel BAZIN  <jnbazin@pc-disi-026.enst-bretagne.fr>
-- Company    :
-- Created    : 2018-04-11
-- Last update: 2019-02-13
-- Platform   :
-- Standard   : VHDL'93/02
-------------------------------------------------------------------------------
-- Description: Operative unit of a sequential FIR filter. Including shift
-- register for samples, registers for coefficients, a MAC and a register to
-- store the result
-------------------------------------------------------------------------------
-- Copyright (c) 2018
-------------------------------------------------------------------------------
-- Revisions  :
-- Date        Version  Author  Description
-- 2019-02-13  1.1      marzel  Update to provide a 16-tap filter and improve
--                              the user experience ;)
-- 2018-04-11  1.0      jnbazin Created
-- 2018-04-18  1.0      marzel  Modification of SR_Y assignment to a round
--                              instead of a trunc
-------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity FIR_129 is

  port (
    I_clock          : in  std_logic;   -- global clock
    I_reset          : in  std_logic;   -- asynchronous global reset
    I_inputSample    : in  std_logic_vector(7 downto 0);  -- 8 bit input sample
    I_loadShift      : in  std_logic;  -- Control signal to load the input sample in the sample shift register and shift the register
    I_initAddress    : in  std_logic;  -- Control signal to initialize register read address
    I_incrAddress    : in  std_logic;  -- Control signal to increment register read address
    I_initSum        : in  std_logic;  -- Control signal to initialize the MAC register
    I_loadSum        : in  std_logic;  -- Control signal to load the MAC register;
    I_loadY          : in  std_logic;   -- Control signal to load Y register
    O_processingDone : out std_logic;   -- Indicate that processing is done
    O_Y              : out std_logic_vector(7 downto 0)   -- filtered sample
    );

end entity FIR_129;

architecture arch_FIR_129 of FIR_129 is
  type registerFile is array(0 to 15) of signed(7 downto 0);
  signal SR_coefRegister : registerFile;
  signal temp : registerFile;

  signal SR_shiftRegister : registerFile;  -- shift register file used to store and shift input samples
  signal SC_multOperand1  : signed(7 downto 0);
  signal SC_multOperand2  : signed(7 downto 0);
  signal SC_MultResult    : signed(15 downto 0);  -- Result of the multiplication Xi*Hi
  signal SC_addResult     : signed(19 downto 0);  -- result of the accumulation addition
  signal SR_sum           : signed(19 downto 0);  -- Accumulation register
  signal SR_Y             : signed(7 downto 0);  -- filtered sample storage register
  signal SR_readAddress   : integer range 0 to 15;  -- register files read address



begin

-- Low-pass filter provided with octave (or Matlab ;)) command
--fir1(15, .001)/sqrt(sum(fir1(15, .001).^2))*2^6
  SR_coefRegister <= (to_signed(2, 8),  -- ROM register used file to store FIR coefficients
                      to_signed(3, 8),
                      to_signed(6, 8),
                      to_signed(10, 8),
                      to_signed(15, 8),
                      to_signed(20, 8),
                      to_signed(24, 8),
                      to_signed(26, 8),
                      to_signed(26, 8),
                      to_signed(24, 8),
                      to_signed(20, 8),
                      to_signed(15, 8),
                      to_signed(10, 8),
                      to_signed(6, 8),
                      to_signed(3, 8),
                      to_signed(2, 8)
                      );



  shift : process (I_clock, I_reset) is
  
  begin  -- process shift
    if I_reset = '1' then               -- asynchronous reset (active high)
      SR_shiftRegister <= (others => (others => '0'));
    elsif rising_edge(I_clock) then     -- rising clock edge
       if (I_loadShift = '1') then
        -- temp <= SR_shiftRegister;
        SR_shiftRegister(1 to 15) <= SR_shiftRegister(0 to 14);
        SR_shiftRegister(0) <= signed(I_inputSample);
       end if;
    end if;
  end process shift;

  incr_address : process (I_clock, I_reset) is
  begin
    if I_reset = '1' then               -- asynchronous reset (active high)
      SR_readAddress <= 0;
    elsif rising_edge(I_clock) then     -- rising clock edge
      if I_incrAddress = '1' then
         if SR_readAddress = 15 then
            SR_readAddress <= 0;
         else
            SR_readAddress <= SR_readAddress + 1;
         end if;
       end if;
    end if;
  end process incr_address;

  O_processingDone <= '1' when (SR_readAddress = 15) ;

  SC_multOperand1 <= SR_shiftRegister(SR_readAddress) ;   -- 8 bits
  SC_multOperand2 <= SR_coefRegister(SR_readAddress) ;    -- 8 bits
  
  
  --SC_MultResult   <= SC_multOperand1 * SC_multOperand2 ;  -- 16 bits
  --SC_addResult    <= resize(SC_MultResult, SC_addResult'length) + SR_sum;

  
end architecture arch_FIR_11;
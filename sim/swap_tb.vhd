-------------------------------------------------------------------------------
-- Title      : Swab Byte testbench
-- Project    : 
-------------------------------------------------------------------------------
-- File       : swap_tb.vhd
-- Author     : Ivano Bonesana  <ivano.bonesana@gmail.com>
-- Company    : 
-- Created    : 2013-05-05
-- Last update: 2013-05-05
-- Platform   : 
-- Standard   : VHDL'93
-------------------------------------------------------------------------------
-- Description: 
-------------------------------------------------------------------------------
-- Copyright (c) 2013 
-------------------------------------------------------------------------------
-- Revisions  :
-- Date        Version  Author  Description
-- 2013-05-05  1.0      Ivano   Created
-------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;

library work;
use work.sha_pack.all;


entity swap_tb is

end entity swap_tb;


architecture test of swap_tb is

   signal x : std_logic_vector(127 downto 0);
   signal y : std_logic_vector(127 downto 0);
begin  -- architecture test

   stim : process
   begin

      x <=  X"01234567012345670123456701234567";
      wait for 10 ns;

      y <= Byte_Swap(x);
      wait for 10 ns;

      wait;
   end process stim;

end architecture test;

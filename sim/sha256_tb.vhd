-------------------------------------------------------------------------------
-- Title      : Testbench for design "sha256"
-- Project    : 
-------------------------------------------------------------------------------
-- File       : sha256_tb.vhd
-- Author     : Ivano Bonesana  <ivano.bonesana@gmail.com>
-- Company    : 
-- Created    : 2013-04-30
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
-- 2013-04-30  1.0      Ivano   Created
-------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;

-------------------------------------------------------------------------------

entity sha256_tb is

end entity sha256_tb;

-------------------------------------------------------------------------------

architecture test of sha256_tb is

   -- component ports
   signal clk     : std_logic := '0';
   signal reset_n : std_logic;

   -- "abc"
   --constant G_DATA_LENGTH : integer := 24;
   --signal data_i : std_logic_vector(G_DATA_LENGTH-1 downto 0) := "011000010110001001100011";
   --signal result : std_logic_vector(255 downto 0)             := X"BA7816BF8F01CFEA414140DE5DAE2223B00361A396177A9CB410FF61F20015AD";
   -- result: BA7816BF 8F01CFEA 414140DE 5DAE2223 B00361A3 96177A9C B410FF61 F20015AD

   -- "abcdbcdecdefdefgefghfghighijhijkijkljklmklmnlmnomnopnopq"
   constant G_DATA_LENGTH : integer                                    := 448;
   signal   data_i        : std_logic_vector(G_DATA_LENGTH-1 downto 0) := X"6162636462636465636465666465666765666768666768696768696a68696a6b696a6b6c6a6b6c6d6b6c6d6e6c6d6e6f6d6e6f706e6f7071";
   signal   result        : std_logic_vector(255 downto 0)             := X"248D6A61D20638B8E5C026930C3E6039A33CE45964FF2167F6ECEDD419DB06C1";
   -- result: 248D6A61 D20638B8 E5C02693 0C3E6039 A33CE459 64FF2167 F6ECEDD4 19DB06C1

   signal digest_o : std_logic_vector(255 downto 0);

begin  -- architecture test

   -- component instantiation
   DUT : entity work.sha256
      generic map (
         G_DATA_LENGTH => G_DATA_LENGTH)
      port map (
         clk      => clk,
         reset_n  => reset_n,
         data_i   => data_i,
         digest_o => digest_o);

   -- clock generation
   Clk <= not Clk after 10 ns;

   -- waveform generation
   WaveGen_Proc : process
   begin
      -- insert signal assignments here
      reset_n <= '0';
      wait for 10 ns;
      reset_n <= '1';
      wait for 100 ns;

      assert digest_o /= result report "OK" severity note;
      assert digest_o = result report "ERROR" severity note;

      wait;
   end process WaveGen_Proc;

   

end architecture test;

-------------------------------------------------------------------------------

configuration sha256_tb_test_cfg of sha256_tb is
   for test
   end for;
end sha256_tb_test_cfg;

-------------------------------------------------------------------------------

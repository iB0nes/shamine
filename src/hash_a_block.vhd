-------------------------------------------------------------------------------
-- Title      : Hash a Block of Data
-- Project    : 
-------------------------------------------------------------------------------
-- File       : hash_a_block.vhd
-- Author     : Ivano Bonesana  <ivano.bonesana@gmail.com>
-- Company    : 
-- Created    : 2013-05-19
-- Last update: 2013-05-19
-- Platform   : 
-- Standard   : VHDL'93
-------------------------------------------------------------------------------
-- Description: Executing SHA256(SHA256(data)) of a block of 640-bit of data
-------------------------------------------------------------------------------
-- Copyright (c) 2013 
-------------------------------------------------------------------------------
-- Revisions  :
-- Date        Version  Author  Description
-- 2013-05-19  1.0      Ivano   Created
-------------------------------------------------------------------------------


library ieee;
use ieee.std_logic_1164.all;

library work;
use work.sha_pack.all;


entity hash_a_block is
   
   port (
      clk     : in  std_logic;
      reset_n : in  std_logic;
      data_i  : in  std_logic_vector(639 downto 0);
      hash_o  : out std_logic_vector(255 downto 0);
      done_o  : out std_logic);

end entity hash_a_block;


architecture behavioral of hash_a_block is

   -- component ports
   signal reset_n_256  : std_logic;
   signal s_digest_640 : std_logic_vector(255 downto 0);
   signal s_digest_256 : std_logic_vector(255 downto 0);

begin  -- architecture behavioral

   sha256_640_1 : entity work.sha256_640
      port map (
         clk      => clk,
         reset_n  => reset_n,
         data_i   => data_i,
         digest_o => s_digest_640,
         done_o   => reset_n_256);

   -- component instantiation
   SHA256 : entity work.sha256_256
      port map (
         clk      => clk,
         reset_n  => reset_n_256,
         data_i   => s_digest_640,
         digest_o => s_digest_256,
         done_o   => done_o);

   -- generate output (maybe swapped?)
   hash_o <= s_digest_256;

end architecture behavioral;


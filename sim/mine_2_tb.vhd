-------------------------------------------------------------------------------
-- Title      : Testbench for design "sha256"
-- Project    : 
-------------------------------------------------------------------------------
-- File       : sha256_tb.vhd
-- Author     : Ivano Bonesana  <ivano.bonesana@gmail.com>
-- Company    : 
-- Created    : 2013-04-30
-- Last update: 2013-05-19
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
use ieee.std_logic_unsigned.all;

library work;
use work.sha_pack.all;

-------------------------------------------------------------------------------

entity mine_2_tb is

end entity mine_2_tb;

-------------------------------------------------------------------------------

architecture test of mine_2_tb is

   type block_type is record
      ver        : std_logic_vector(31 downto 0);
      prev_block : std_logic_vector(255 downto 0);
      mrkl_root  : std_logic_vector(255 downto 0);
      t          : std_logic_vector(31 downto 0);
      bits       : std_logic_vector(31 downto 0);
      nonce      : std_logic_vector(31 downto 0);
   end record block_type;
   --
   ----------------------------------------------------------------------------
   --
   -- hash: 000000000000013425ea94675d9561319ab56d790312bf02147f1367c6ecdb83
   constant block_to_hash_1 : block_type := (
      X"00000002",
      X"00000000000000e0200798a368357438b093a7b41d0edee7d30a0d52592a66ed",
      --X"0000000000000000000000000000000000000000000000000000000000000000",
      X"9ce189edbc4cd761b26f9d1373773ac1b0d61969c454ad1829d9eea01ed1f4ee",
      X"516AF907",                      -- 1365965063
      X"1A022FBE",                      -- 436350910
      X"F0D5E704");                     -- 4040550148
   --
   -- hash: 00000000000000001e8d6829a8a21adc5d38d0a473b144b6765798e61f98bd1d
   constant block_to_hash_2 : block_type := (
      X"00000001",
      X"00000000000008a3a41b85b8b29ad444def299fee21793cd8b9e567eab02cd81",
      X"2b12fcf1b09288fcaff797d71e950e71ae42b91e8bdb2304758dfcffc2b620e3",
      X"4DD7F5C7",                      -- 1305998791
      X"1A44B9F2",                      -- 440711666
      X"9546A142");                     -- 2504433986
   --
   -- haash: 000000000019d6689c085ae165831e934ff763ae46a2a6c172b3f1b60a8ce26f
   constant block_to_hash_ok : block_type := (
      X"00000001",
      X"0000000000000000000000000000000000000000000000000000000000000000",
      X"4a5e1e4baab89f3a32518a88c31bc87f618f76673e2cc77ab2127b7afdeda33b",
      X"495FAB29",                      -- 1231006505
      X"1D00FFFF",                      -- 486604799
      X"7C2BAC1D");                     -- 2083236893
   --
   --
   constant block_to_hash_boh : block_type := (
      X"00000002",
      X"c7df777a0cefe1edc881869862a714673ead52afadaa50ad000000b200000000",
      X"4ad9a392abd982768fe39135443838b358793c0ea6627b83316ec0ea6873c806",
      X"518808b3",
      X"1a01aa3d",
      X"00000000");
   --X"00000080",
   --0000000000000000000000000000000000000000000000000000000000000000000000000000000080020000
   --
   ----------------------------------------------------------------------------
   --
   -- component generics
   --constant G_DATA_LENGTH : integer                        := 640;
   --
   -- component ports
   signal clk           : std_logic                      := '0';
   signal reset_n       : std_logic;
   signal reset_n_256   : std_logic;
   signal data_i        : std_logic_vector(639 downto 0) := (others => '0');
   signal digest_sha324 : std_logic_vector(255 downto 0);
   signal digest_o      : std_logic_vector(255 downto 0);
   signal digest_o_r    : std_logic_vector(255 downto 0);
   --
   ----------------------------------------------------------------------------
   --
   
begin  -- architecture test

   sha256_640_1 : entity work.sha256_640
      port map (
         clk      => clk,
         reset_n  => reset_n,
         data_i   => data_i,
         digest_o => digest_sha324,
         done_o   => reset_n_256);

   -- component instantiation
   SHA256 : entity work.sha256_256
      port map (
         clk      => clk,
         reset_n  => reset_n_256,
         data_i   => digest_sha324,
         digest_o => digest_o,
         done_o   => open);

   digest_o_r <= Byte_Swap(digest_o);

   -- clock generation
   Clk <= not Clk after 10 ns;

   -- waveform generation
   WaveGen_Proc : process
   begin
      -- insert signal assignments here
      reset_n <= '0';

      -- build input sequence
      data_i <= Byte_Swap(block_to_hash_1.ver) &
                ---------------------------------------------------------------
                Byte_Swap(block_to_hash_1.prev_block) &
                ---------------------------------------------------------------
                Byte_Swap(block_to_hash_1.mrkl_root) &
                ---------------------------------------------------------------
                Byte_Swap(block_to_hash_1.t) &
                ---------------------------------------------------------------
                Byte_Swap(block_to_hash_1.bits) &
                ---------------------------------------------------------------
                Byte_Swap(block_to_hash_1.nonce);

      --data_i <= Byte_Swap(block_to_hash_2.ver) &
      --          ---------------------------------------------------------------
      --          Byte_Swap(block_to_hash_2.prev_block) &
      --          ---------------------------------------------------------------
      --          Byte_Swap(block_to_hash_2.mrkl_root) &
      --          ---------------------------------------------------------------
      --          Byte_Swap(block_to_hash_2.t) &
      --          ---------------------------------------------------------------
      --          Byte_Swap(block_to_hash_2.bits) &
      --          ---------------------------------------------------------------
      --          Byte_Swap(block_to_hash_2.nonce);

      --data_i <= Byte_Swap(block_to_hash_ok.ver) &
      --          ---------------------------------------------------------------
      --          Byte_Swap(block_to_hash_ok.prev_block) &
      --          ---------------------------------------------------------------
      --          Byte_Swap(block_to_hash_ok.mrkl_root) &
      --          ---------------------------------------------------------------
      --          Byte_Swap(block_to_hash_ok.t) &
      --          ---------------------------------------------------------------
      --          Byte_Swap(block_to_hash_ok.bits) &
      --          ---------------------------------------------------------------
      --          Byte_Swap(block_to_hash_ok.nonce);

      --data_i <= Byte_Swap(block_to_hash_boh.ver) &
      --          ---------------------------------------------------------------
      --          Byte_Swap(block_to_hash_boh.prev_block) &
      --          ---------------------------------------------------------------
      --          Byte_Swap(block_to_hash_boh.mrkl_root) &
      --          ---------------------------------------------------------------
      --          Byte_Swap(block_to_hash_boh.t) &
      --          ---------------------------------------------------------------
      --          Byte_Swap(block_to_hash_boh.bits) &
      --          ---------------------------------------------------------------
      --          Byte_Swap(block_to_hash_boh.nonce);

      --wait for 10 ns;

      --data_i <= Byte_Swap(data_i);

      --data_i <= Byte_Swap(X"000000027e6368d0f3a90a3c03441104b270ac8d0c7ef5b0f0daa83400000191000000009c5e9720c5171c710fc1df001a733395fa6f1129a801cd9efafb0314c6878ce55187fdf01a01aa3d00000000000000800000000000000000000000000000000000000000000000000000000000000000000000000000000080020000");

      --data_i <= (X"0100000000000000000000000000000000000000000000000000000000000000000000003ba3edfd7a7b12b27ac72c3e67768f617fc81bc3888a51323a9fb8aa4b1e5e4a29ab5f49ffff001d1dac2b7c");

      wait for 10 ns;
      reset_n <= '1';

      wait;
   end process WaveGen_Proc;

end architecture test;


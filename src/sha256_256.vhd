-------------------------------------------------------------------------------
-- Title      : SHA-256 for 256 bits blocks
-- Project    : 
-------------------------------------------------------------------------------
-- File       : sha256_256.vhd
-- Author     : Ivano Bonesana  <ivano.bonesana@gmail.com>
-- Company    : 
-- Created    : 2013-05-19
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
-- 2013-05-19  1.0      Ivano   Created
-------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;

library work;
use work.sha_pack.all;

entity sha256_256 is
   generic(
      G_DATA_LENGTH : integer := 256;
      BUFFER_LENGTH : integer := 512);
   port (
      clk      : in  std_logic;
      reset_n  : in  std_logic;
      data_i   : in  std_logic_vector(G_DATA_LENGTH-1 downto 0);
      digest_o : out std_logic_vector(255 downto 0);
      done_o   : out std_logic);   
end entity sha256_256;


architecture behavioral of sha256_256 is

   -- the message blocks
   signal s_m        : dw_array(0 to 15);
   -- hashing support variables
   signal s_hash_out : dw_array(0 to 7) := (others => (others => '0'));
   signal start      : std_logic        := '0';

   component sha256_hashing is
      port (
         clk     : in  std_logic;
         reset_n : in  std_logic;
         start   : in  std_logic;
         m       : in  dw_array(0 to 15);
         hash_i  : in  dw_array(0 to 7);
         done    : out std_logic;
         hash_o  : out dw_array(0 to 7));
   end component sha256_hashing;
   
begin  -- architecture behavioral

   -- purpose: Execute preprocessing operations
   -- type   : sequential
   -- inputs : clk, reset_n, data_i
   -- outputs: s_m
   Preprocessing_Data : process (clk, reset_n) is
      variable v_padded_data : std_logic_vector(BUFFER_LENGTH-1 downto 0);
   begin  -- process Preprocessing_Data
      if reset_n = '0' then               -- asynchronous reset (active low)
         s_m           <= (others => (others => '0'));
         start         <= '0';
         v_padded_data := (others => '0');
      elsif clk'event and clk = '1' then  -- rising clock edge
         -- Refer to section 6.2.1 of fips-180-4
         -- 2. The message is padded and parsed as specified in Section 5.
         v_padded_data                                                         := (others => '0');
         v_padded_data(BUFFER_LENGTH-1 downto BUFFER_LENGTH-1-G_DATA_LENGTH+1) := data_i;
         v_padded_data(BUFFER_LENGTH-1-G_DATA_LENGTH)                          := '1';
         v_padded_data(BUFFER_LENGTH-512+63 downto BUFFER_LENGTH-512)      := conv_std_logic_vector(G_DATA_LENGTH, 64);

         for i in 0 to 15 loop
            s_m(i) <= v_padded_data(BUFFER_LENGTH-1-32*i downto BUFFER_LENGTH-1-32*i-31);
         end loop;  -- i

         start <= '1';
      end if;
   end process Preprocessing_Data;

   -- 1. Set the initial hash value, H(0), as specified in Sec. 5.3.3.
   sha256_hashing_instance : sha256_hashing
      port map (
         clk     => clk,
         reset_n => reset_n,
         start   => start,
         m       => s_m,
         hash_i  => sha_h,
         done    => done_o,
         hash_o  => s_hash_out);

   digest_o <= s_hash_out(0) & s_hash_out(1) & s_hash_out(2) & s_hash_out(3) & s_hash_out(4) & s_hash_out(5) & s_hash_out(6) & s_hash_out(7);

end architecture behavioral;

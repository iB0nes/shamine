-------------------------------------------------------------------------------
-- Title      : SHA-256 Hashing Loop
-- Project    : 
-------------------------------------------------------------------------------
-- File       : sha256_hashing.vhd
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
use ieee.std_logic_unsigned.all;

library work;
use work.sha_pack.all;


entity sha256_hashing is
   port(
      clk     : in  std_logic;
      reset_n : in  std_logic;
      start   : in  std_logic;
      m       : in  dw_array(0 to 15);
      hash_i  : in  dw_array(0 to 7);
      done    : out std_logic;
      hash_o  : out dw_array(0 to 7));
end entity sha256_hashing;


architecture behavioral of sha256_hashing is
   type   state_type is(ST_INIT_W_H, ST_HASH, ST_OUTPUT);
   signal s_st : state_type;
   --
   signal s_w  : dw_array(0 to 63);
   --signal s_hash : dw_array(0 to 7) := (others => (others => '0'));
   
begin  -- architecture behavioral

   FSM : process (clk, reset_n) is
      -- working variables
      variable v_w         : dw_array(0 to 63);
      --
      variable T1          : std_logic_vector(31 downto 0);
      variable T2          : std_logic_vector(31 downto 0);
      --
      variable v_next_hash : dw_array(0 to 7);
      alias a              : std_logic_vector(31 downto 0) is v_next_hash(0);
      alias b              : std_logic_vector(31 downto 0) is v_next_hash(1);
      alias c              : std_logic_vector(31 downto 0) is v_next_hash(2);
      alias d              : std_logic_vector(31 downto 0) is v_next_hash(3);
      alias e              : std_logic_vector(31 downto 0) is v_next_hash(4);
      alias f              : std_logic_vector(31 downto 0) is v_next_hash(5);
      alias g              : std_logic_vector(31 downto 0) is v_next_hash(6);
      alias h              : std_logic_vector(31 downto 0) is v_next_hash(7);
      --
      -------------------------------------------------------------------------
   begin  -- process FSM
      
      if reset_n = '0' then             -- asynchronous reset (active low)
         
         s_st   <= ST_INIT_W_H;
         hash_o <= (others => (others => '0'));
         done   <= '0';
         
      elsif clk'event and clk = '1' then  -- rising clock edge
         
         case s_st is
            
            when ST_INIT_W_H =>
               -- 1. prepare the message schedule W
               for t in 0 to 15 loop
                  v_w(t) := m(t);
               end loop;  -- t

               for t in 16 to 63 loop
                  v_w(t) := sigma_1(v_w(t-2)) + v_w(t-7) + sigma_0(v_w(t-15)) + v_w(t-16);
               end loop;  -- t

               -- update signal for next state
               s_w <= v_w;

               hash_o <= (others => (others => '0'));
               done   <= '0';

               -- update state
               if start = '1' then
                  s_st <= ST_HASH;
               else
                  s_st <= ST_INIT_W_H;
               end if;

               -------------------------------------------------------------------
               
            when ST_HASH =>
               -- 2. initialize the working variables a..h with the (i-1)st hash
               a := hash_i(0);
               b := hash_i(1);
               c := hash_i(2);
               d := hash_i(3);
               e := hash_i(4);
               f := hash_i(5);
               g := hash_i(6);
               h := hash_i(7);

               -- 3.
               for t in 0 to 63 loop
                  T1 := h + Sum_1(e) + Ch(e, f, g) + K(t) + v_w(t);
                  T2 := Sum_0(a) + Maj(a, b, c);
                  h  := g;
                  g  := f;
                  f  := e;
                  e  := d + T1;
                  d  := c;
                  c  := b;
                  b  := a;
                  a  := T1 + T2;
               end loop;  -- t

               -- update state
               s_st <= ST_OUTPUT;

               hash_o <= (others => (others => '0'));
               done   <= '0';

               -------------------------------------------------------------------
               
            when ST_OUTPUT =>
               -- 4. compute the ith intermadiate hash value H
               for t in 0 to 7 loop
                  hash_o(t) <= v_next_hash(t) + hash_i(t);
               end loop;  -- t           

               done <= '1';

               -- update state
               if start = '0' then
                  s_st <= ST_INIT_W_H;
               else
                  s_st <= ST_OUTPUT;
               end if;

               -------------------------------------------------------------------
               
            when others =>
               s_st   <= ST_INIT_W_H;
               hash_o <= (others => (others => '0'));
               done   <= '0';
               
         end case;
      end if;
   end process FSM;

end architecture behavioral;



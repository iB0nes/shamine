-------------------------------------------------------------------------------
-- Title      : SHA-256 hashing algorithm
-- Project    : 
-------------------------------------------------------------------------------
-- File       : sha256.vhd
-- Author     : Ivano Bonesana  <ivano.bonesana@gmail.com>
-- Company    : 
-- Created    : 2013-04-29
-- Last update: 2013-05-06
-- Platform   : 
-- Standard   : VHDL'93
-------------------------------------------------------------------------------
-- Description: 
-------------------------------------------------------------------------------
-- Copyright (c) 2013 
-------------------------------------------------------------------------------
-- Revisions  :
-- Date        Version  Author  Description
-- 2013-04-29  1.0      Ivano   Created
-------------------------------------------------------------------------------


library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

library work;
use work.sha_pack.all;

entity sha256 is
   generic(
      G_DATA_LENGTH : integer := 24;
      BUFFER_LENGTH : integer := 2048
      );
   port (
      clk      : in  std_logic;
      reset_n  : in  std_logic;
      data_i   : in  std_logic_vector(G_DATA_LENGTH-1 downto 0);
      digest_o : out std_logic_vector(255 downto 0));
end sha256;


architecture behavioral of sha256 is
begin  -- architecture behavioral
   
   SHA : process(clk, reset_n, data_i) is
      variable v_padded_data : std_logic_vector(BUFFER_LENGTH-1 downto 0);
      --variable v_len         : integer           := 0;
      -- the message blocks
      variable m             : block_array(0 to 4);  -- max of 1024 bits
      variable n             : integer;              -- number of blocks
      -- hashing support variables
      variable hash          : dw_array(0 to 7)  := (others => (others => '0'));
      variable next_hash     : dw_array(0 to 7)  := (others => (others => '0'));
      -- working variables
      alias a                : std_logic_vector(31 downto 0) is next_hash(0);
      alias b                : std_logic_vector(31 downto 0) is next_hash(1);
      alias c                : std_logic_vector(31 downto 0) is next_hash(2);
      alias d                : std_logic_vector(31 downto 0) is next_hash(3);
      alias e                : std_logic_vector(31 downto 0) is next_hash(4);
      alias f                : std_logic_vector(31 downto 0) is next_hash(5);
      alias g                : std_logic_vector(31 downto 0) is next_hash(6);
      alias h                : std_logic_vector(31 downto 0) is next_hash(7);
      -- temporary variables
      variable T1            : std_logic_vector(31 downto 0);
      variable T2            : std_logic_vector(31 downto 0);
      -- message schedule
      variable w             : dw_array(0 to 63) := (others => (others => '0'));
      --
   begin  -- process

      if reset_n = '0' then
         digest_o <= (others => '0');
         n        := 0;
      elsif clk'event and clk = '1' then
         ----------------------------------------------------------------------
         -- PREPROCESSING
         --
         -- Refer to section 6.2.1 of fips-180-4
         -- 1. Set the initial hash value, H(0), as specified in Sec. 5.3.3.
         hash                                            := sha_h;
         --
         -- 2. The message is padded and parsed as specified in Section 5.
         v_padded_data                                   := (others => '0');
         n                                               := (G_DATA_LENGTH+1+64)/512;
         --v_len                                                                          := G_DATA_LENGTH + 448-((G_DATA_LENGTH mod 512)+1);
         v_padded_data(BUFFER_LENGTH-1 downto BUFFER_LENGTH-1-G_DATA_LENGTH+1) := data_i;
         v_padded_data(BUFFER_LENGTH-1-G_DATA_LENGTH)               := '1';

         --if n = 0 then
         --   v_padded_data(512 + 63 downto 512) := conv_std_logic_vector(G_DATA_LENGTH, 64);
         --elsif n=1 then            
         --   v_padded_data(63 downto 0) := conv_std_logic_vector(G_DATA_LENGTH, 64);
         --else            
         --end if;

         v_padded_data(BUFFER_LENGTH-512*(n+1)+63 downto BUFFER_LENGTH-512*(n+1)) := conv_std_logic_vector(G_DATA_LENGTH, 64);

         for j in 0 to n loop
            for i in 0 to 15 loop
               m(j)(i) := v_padded_data(BUFFER_LENGTH-1-512*j-32*i downto BUFFER_LENGTH-1-512*j-32*i-31);
            end loop;  -- i
         end loop;  -- j

         ----------------------------------------------------------------------
         -- HASH COMPUTATION
         for i in 0 to n loop
            -- process one block M

            -- 1. prepare the message schedule W
            for t in 0 to 15 loop
               w(t) := m(i)(t);
            end loop;  -- t

            for t in 16 to 63 loop
               w(t) := sigma_1(w(t-2)) + w(t-7) + sigma_0(W(t-15)) + w(t-16);
            end loop;  -- t

            -- 2. initialize the working variables a..h with the (i-1)st hash
            a := hash(0);
            b := hash(1);
            c := hash(2);
            d := hash(3);
            e := hash(4);
            f := hash(5);
            g := hash(6);
            h := hash(7);

            -- 3.
            for t in 0 to 63 loop
               T1 := h + Sum_1(e) + Ch(e, f, g) + K(t) + w(t);
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

            -- 4. compute the ith intermadiate hash value H
            for t in 0 to 7 loop
               hash(t) := next_hash(t) + hash(t);
            end loop;  -- t           
            
         end loop;  -- i
         ----------------------------------------------------------------------         
         digest_o <= hash(0) & hash(1) & hash(2) & hash(3) & hash(4) & hash(5) & hash(6) & hash(7);
      end if;
   end process SHA;
   

end architecture behavioral;


--architecture behavioral of sha256 is
--begin  -- behavioral

--  process (clk, reset_n)
--    variable s0   : std_logic_vector(31 downto 0);
--    variable s1   : std_logic_vector(31 downto 0);
--    variable ch   : std_logic_vector(31 downto 0);
--    variable temp : std_logic_vector(31 downto 0);
--    variable maj  : std_logic_vector(31 downto 0);
--    --
--    -- the 512-bits chunks
--    variable w    : dw_array(0 to 63) := (others => (others => '0'));
--    --
--    -- hash value
--    variable hash : dw_array(0 to 7)  := sha_h;
--    alias a       : std_logic_vector(31 downto 0) is hash(0);
--    alias b       : std_logic_vector(31 downto 0) is hash(1);
--    alias c       : std_logic_vector(31 downto 0) is hash(2);
--    alias d       : std_logic_vector(31 downto 0) is hash(3);
--    alias e       : std_logic_vector(31 downto 0) is hash(4);
--    alias f       : std_logic_vector(31 downto 0) is hash(5);
--    alias g       : std_logic_vector(31 downto 0) is hash(6);
--    alias h       : std_logic_vector(31 downto 0) is hash(7);

--  begin  -- process

--    if reset_n = '0' then               -- asynchronous reset (active low)

--      w := (others => (others => '0'));

--    elsif clk'event and clk = '1' then  -- rising clock edge

--      for i in 16 to 63 loop
--        s0   := rotate_right(w(i-15), 7) xor rotate_right(w(i-15), 18) xor shift_right(w(i-15), 3);
--        s1   := rotate_right(w(i-2), 17) xor rotate_right(w(i-2), 19) xor shift_right(w(i-2), 10);
--        w(i) := w(i-16) + s0 + w(i-7) + s1;
--      end loop;  -- i

--      -- main loop
--      for i in 0 to 63 loop
--        s1   := rotate_right(e, 6) xor rotate_right(e, 11) xor rotate_right(e, 25);
--        ch   := (e and f) xor ((not e) and g);
--        temp := h+s1+ch+k(i)+w(i);
--        d    := d+temp;
--        s0   := rotate_right(a, 2) xor rotate_right(a, 13) xor rotate_right(a, 22);
--        maj  := (a and (b xor c)) xor (b and c);
--        temp := temp+s0+maj;
--        --
--        h    := g;
--        g    := f;
--        f    := e;
--        e    := d;
--        d    := c;
--        c    := b;
--        c    := a;
--        a    := temp;
--        --
--      end loop;  -- i      

--      hash(0) := h(0) + a;
--      hash(1) := h(1)+b;
--      hash(2) := h(2)+c;
--      hash(3) := h(3)+d;
--      hash(4) := h(4)+e;
--      hash(5) := h(5)+f;
--      hash(6) := h(6)+g;
--      hash(7) := h(7)+h;

--      digest_o <= hash(0) & hash(1) & hash(2) & hash(3) & hash(4) & hash(5) & hash(6) & hash(7);

--    end if;
--  end process;

--end behavioral;

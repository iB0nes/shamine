-------------------------------------------------------------------------------
-- Title      : SHA Package
-- Project    : 
-------------------------------------------------------------------------------
-- File       : sha_pack.vhd
-- Author     :   <Ivano@RAUROS>
-- Company    : 
-- Created    : 2013-04-27
-- Last update: 2013-05-05
-- Platform   : 
-- Standard   : VHDL'87
-------------------------------------------------------------------------------
-- Description: 
-------------------------------------------------------------------------------
-- Copyright (c) 2013 
-------------------------------------------------------------------------------
-- Revisions  :
-- Date        Version  Author  Description
-- 2013-04-27  1.0      Ivano   Created
-------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;

package sha_pack is

   type dw_array is array (integer range <>) of std_logic_vector(31 downto 0);
   type ddw_array is array (integer range <>) of std_logic_vector(63 downto 0);
   type block_array is array (integer range <>) of dw_array(0 to 15);  -- blocks of 512 bits (16 slices of 32 bits)

   -- the first 32 bits of the fractional parts of the sqare roots of the first 8 primes (2..19)
   -- Refer to section 5.3.3 of fips-180-4
   constant sha_h : dw_array(0 to 7) := (X"6a09e667",
                                         X"bb67ae85",
                                         X"3c6ef372",
                                         X"a54ff53a",
                                         X"510e527f",
                                         X"9b05688c",
                                         X"1f83d9ab",
                                         X"5be0cd19");


   -- The first tirty-two bits of the fractional parts of the cube roots of the first 64 prime numbers.
   -- Refer to section 4.2.2 of fips-180-4
   constant K : dw_array(0 to 63) := (
      X"428a2f98", X"71374491", X"b5c0fbcf", X"e9b5dba5", X"3956c25b", X"59f111f1", X"923f82a4", X"ab1c5ed5",
      X"d807aa98", X"12835b01", X"243185be", X"550c7dc3", X"72be5d74", X"80deb1fe", X"9bdc06a7", X"c19bf174",
      X"e49b69c1", X"efbe4786", X"0fc19dc6", X"240ca1cc", X"2de92c6f", X"4a7484aa", X"5cb0a9dc", X"76f988da",
      X"983e5152", X"a831c66d", X"b00327c8", X"bf597fc7", X"c6e00bf3", X"d5a79147", X"06ca6351", X"14292967",
      X"27b70a85", X"2e1b2138", X"4d2c6dfc", X"53380d13", X"650a7354", X"766a0abb", X"81c2c92e", X"92722c85",
      X"a2bfe8a1", X"a81a664b", X"c24b8b70", X"c76c51a3", X"d192e819", X"d6990624", X"f40e3585", X"106aa070",
      X"19a4c116", X"1e376c08", X"2748774c", X"34b0bcb5", X"391c0cb3", X"4ed8aa4a", X"5b9cca4f", X"682e6ff3",
      X"748f82ee", X"78a5636f", X"84c87814", X"8cc70208", X"90befffa", X"a4506ceb", X"bef9a3f7", X"c67178f2");

   -- The first sixty-four bits of the fractional parts of the cube roots of the first 80 prime numbers.
   -- Refer to section 4.2.3 of fips-180-4
   constant K_64 : ddw_array(0 to 79) := (
      X"428a2f98d728ae22", X"7137449123ef65cd", X"b5c0fbcfec4d3b2f", X"e9b5dba58189dbbc",
      X"3956c25bf348b538", X"59f111f1b605d019", X"923f82a4af194f9b", X"ab1c5ed5da6d8118",
      X"d807aa98a3030242", X"12835b0145706fbe", X"243185be4ee4b28c", X"550c7dc3d5ffb4e2",
      X"72be5d74f27b896f", X"80deb1fe3b1696b1", X"9bdc06a725c71235", X"c19bf174cf692694",
      X"e49b69c19ef14ad2", X"efbe4786384f25e3", X"0fc19dc68b8cd5b5", X"240ca1cc77ac9c65",
      X"2de92c6f592b0275", X"4a7484aa6ea6e483", X"5cb0a9dcbd41fbd4", X"76f988da831153b5",
      X"983e5152ee66dfab", X"a831c66d2db43210", X"b00327c898fb213f", X"bf597fc7beef0ee4",
      X"c6e00bf33da88fc2", X"d5a79147930aa725", X"06ca6351e003826f", X"142929670a0e6e70",
      X"27b70a8546d22ffc", X"2e1b21385c26c926", X"4d2c6dfc5ac42aed", X"53380d139d95b3df",
      X"650a73548baf63de", X"766a0abb3c77b2a8", X"81c2c92e47edaee6", X"92722c851482353b",
      X"a2bfe8a14cf10364", X"a81a664bbc423001", X"c24b8b70d0f89791", X"c76c51a30654be30",
      X"d192e819d6ef5218", X"d69906245565a910", X"f40e35855771202a", X"106aa07032bbd1b8",
      X"19a4c116b8d2d0c8", X"1e376c085141ab53", X"2748774cdf8eeb99", X"34b0bcb5e19b48a8",
      X"391c0cb3c5c95a63", X"4ed8aa4ae3418acb", X"5b9cca4f7763e373", X"682e6ff3d6b2b8a3",
      X"748f82ee5defb2fc", X"78a5636f43172f60", X"84c87814a1f0ab72", X"8cc702081a6439ec",
      X"90befffa23631e28", X"a4506cebde82bde9", X"bef9a3f7b2c67915", X"c67178f2e372532b",
      X"ca273eceea26619c", X"d186b8c721c0c207", X"eada7dd6cde0eb1e", X"f57d4f7fee6ed178",
      X"06f067aa72176fba", X"0a637dc5a2c898a6", X"113f9804bef90dae", X"1b710b35131c471b",
      X"28db77f523047d84", X"32caab7b40c72493", X"3c9ebe0a15c9bebc", X"431d67c49c100d4c",
      X"4cc5d4becb3e42b6", X"597f299cfc657e2a", X"5fcb6fab3ad6faec", X"6c44198c4a475817"
      );


   -- 32-bit words
   function rotate_left(x  : std_logic_vector(31 downto 0); n : integer) return std_logic_vector;
   function rotate_right(x : std_logic_vector(31 downto 0); n : integer) return std_logic_vector;
   function shift_left(x   : std_logic_vector(31 downto 0); n : integer) return std_logic_vector;
   function shift_right(x  : std_logic_vector(31 downto 0); n : integer) return std_logic_vector;

   -- 64-bits words
   function rotate_left_64(x  : std_logic_vector(63 downto 0); n : integer) return std_logic_vector;
   function rotate_right_64(x : std_logic_vector(63 downto 0); n : integer) return std_logic_vector;
   function shift_left_64(x   : std_logic_vector(63 downto 0); n : integer) return std_logic_vector;
   function shift_right_64(x  : std_logic_vector(63 downto 0); n : integer) return std_logic_vector;

   -- SHA-256 Functions for 32-bit words.
   -- Refer to section 4.1.2 of fips-180-4
   -- function 4.2
   function Ch (x      : std_logic_vector(31 downto 0); y : std_logic_vector(31 downto 0); z : std_logic_vector(31 downto 0)) return std_logic_vector;
   -- function 4.3
   function Maj(x      : std_logic_vector(31 downto 0); y : std_logic_vector(31 downto 0); z : std_logic_vector(31 downto 0)) return std_logic_vector;
   -- function 4.4
   function Sum_0 (x   : std_logic_vector(31 downto 0)) return std_logic_vector;
   -- function 4.5
   function Sum_1 (x   : std_logic_vector(31 downto 0)) return std_logic_vector;
   -- function 4.6
   function sigma_0 (x : std_logic_vector(31 downto 0)) return std_logic_vector;
   -- function 4.7
   function sigma_1 (x : std_logic_vector(31 downto 0)) return std_logic_vector;

   -- SHA-256 Functions for 64-bit words.
   -- Refer to section 4.1.3 of fips-180-4
   -- function 4.8
   function Ch_64 (x      : std_logic_vector(63 downto 0); y : std_logic_vector(63 downto 0); z : std_logic_vector(63 downto 0)) return std_logic_vector;
   -- function 4.9
   function Maj_64(x      : std_logic_vector(63 downto 0); y : std_logic_vector(63 downto 0); z : std_logic_vector(63 downto 0)) return std_logic_vector;
   -- function 4.10
   function Sum_0_64 (x   : std_logic_vector(63 downto 0)) return std_logic_vector;
   -- function 4.11
   function Sum_1_64 (x   : std_logic_vector(63 downto 0)) return std_logic_vector;
   -- function 4.12
   function sigma_0_64 (x : std_logic_vector(63 downto 0)) return std_logic_vector;
   -- function 4.13
   function sigma_1_64 (x : std_logic_vector(63 downto 0)) return std_logic_vector;

   function Byte_Swap (x : std_logic_vector) return std_logic_vector;
   
end sha_pack;


package body sha_pack is

   -- 32-bit words
   function rotate_left(x : std_logic_vector(31 downto 0); n : integer) return std_logic_vector is
   begin
      return x(31-n downto 0) & x(31 downto 31-n+1);
   end rotate_left;

   function rotate_right(x : std_logic_vector(31 downto 0); n : integer) return std_logic_vector is
   begin
      return x(n-1 downto 0) & x(31 downto n);
   end rotate_right;

   function shift_left(x : std_logic_vector(31 downto 0); n : integer) return std_logic_vector is
      variable zeros : std_logic_vector(n-1 downto 0) := (others => '0');
   begin
      return x(31-n downto 0) & zeros;
   end shift_left;

   function shift_right(x : std_logic_vector(31 downto 0); n : integer) return std_logic_vector is
      variable zeros : std_logic_vector(n-1 downto 0) := (others => '0');
   begin
      return zeros & x(31 downto n);
   end shift_right;


   -- 64-bit words
   function rotate_left_64(x : std_logic_vector(63 downto 0); n : integer) return std_logic_vector is
   begin
      return x(31-n downto 0) & x(31 downto 31-n+1);
   end rotate_left_64;

   function rotate_right_64(x : std_logic_vector(63 downto 0); n : integer) return std_logic_vector is
   begin
      return x(n-1 downto 0) & x(31 downto n);
   end rotate_right_64;

   function shift_left_64(x : std_logic_vector(63 downto 0); n : integer) return std_logic_vector is
      variable zeros : std_logic_vector(n-1 downto 0) := (others => '0');
   begin
      return x(31-n downto 0) & zeros;
   end shift_left_64;

   function shift_right_64(x : std_logic_vector(63 downto 0); n : integer) return std_logic_vector is
      variable zeros : std_logic_vector(n-1 downto 0) := (others => '0');
   begin
      return zeros & x(31 downto n);
   end shift_right_64;


   -- function 4.2
   function Ch(x : std_logic_vector(31 downto 0); y : std_logic_vector(31 downto 0); z : std_logic_vector(31 downto 0)) return std_logic_vector is
   begin
      return (x and y) xor ((not x) and z);
   end Ch;

   -- function 4.3
   function Maj(x : std_logic_vector(31 downto 0); y : std_logic_vector(31 downto 0); z : std_logic_vector(31 downto 0)) return std_logic_vector is
   begin
      return (x and y) xor (x and z) xor (y and z);
   end Maj;

   -- function 4.4
   function Sum_0 (x : std_logic_vector(31 downto 0)) return std_logic_vector is
   begin
      return rotate_right(x, 2) xor rotate_right(x, 13) xor rotate_right(x, 22);
   end Sum_0;

   -- function 4.5
   function Sum_1 (x : std_logic_vector(31 downto 0)) return std_logic_vector is
   begin
      return rotate_right(x, 6) xor rotate_right(x, 11) xor rotate_right(x, 25);
   end Sum_1;

   -- function 4.6
   function sigma_0 (x : std_logic_vector(31 downto 0)) return std_logic_vector is
   begin
      return rotate_right(x, 7) xor rotate_right(x, 18) xor shift_right(x, 3);
   end sigma_0;

   -- function 4.7
   function sigma_1 (x : std_logic_vector(31 downto 0)) return std_logic_vector is
   begin
      return rotate_right(x, 17) xor rotate_right(x, 19) xor shift_right(x, 10);
   end sigma_1;


   -- function 4.8
   function Ch_64(x : std_logic_vector(63 downto 0); y : std_logic_vector(63 downto 0); z : std_logic_vector(63 downto 0)) return std_logic_vector is
   begin
      return (x and y) xor ((not x) and z);
   end Ch_64;

   -- function 4.9
   function Maj_64(x : std_logic_vector(63 downto 0); y : std_logic_vector(63 downto 0); z : std_logic_vector(63 downto 0)) return std_logic_vector is
   begin
      return (x and y) xor (x and z) xor (y and z);
   end Maj_64;

   -- function 4.10
   function Sum_0_64 (x : std_logic_vector(63 downto 0)) return std_logic_vector is
   begin
      return rotate_right_64(x, 28) xor rotate_right_64(x, 34) xor rotate_right_64(x, 39);
   end Sum_0_64;

   -- function 4.11
   function Sum_1_64 (x : std_logic_vector(63 downto 0)) return std_logic_vector is
   begin
      return rotate_right_64(x, 14) xor rotate_right_64(x, 18) xor rotate_right_64(x, 41);
   end Sum_1_64;

   -- function 4.12
   function sigma_0_64 (x : std_logic_vector(63 downto 0)) return std_logic_vector is
   begin
      return rotate_right_64(x, 1) xor rotate_right_64(x, 8) xor shift_right_64(x, 7);
   end sigma_0_64;

   -- function 4.13
   function sigma_1_64 (x : std_logic_vector(63 downto 0)) return std_logic_vector is
   begin
      return rotate_right_64(x, 19) xor rotate_right_64(x, 61) xor shift_right_64(x, 6);
   end sigma_1_64;


   function Byte_Swap(x : std_logic_vector) return std_logic_vector is
      variable result : std_logic_vector(x'range);
      variable i_max  : integer;
   begin
      i_max := x'left-7;
      for i in x'right to x'left loop
         result(i) := x(i_max+i-16*(i/8));
      end loop;  -- i
      return result;
   end Byte_Swap;
   
end sha_pack;



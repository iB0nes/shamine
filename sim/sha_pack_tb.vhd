-------------------------------------------------------------------------------
-- Title      : Testbench for design "sha_pack"
-- Project    : 
-------------------------------------------------------------------------------
-- File       : sha256_tb.vhd
-- Author     :   <Ivano@RAUROS>
-- Company    : 
-- Created    : 2013-04-27
-- Last update: 2013-04-27
-- Platform   : 
-- Standard   : VHDL'93
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

library work;
use work.sha_pack.all;

-------------------------------------------------------------------------------

entity sha_pack_tb is

end sha_pack_tb;

-------------------------------------------------------------------------------

architecture test of sha_pack_tb is

  signal t : std_logic_vector(31 downto 0) := X"12345678";
  
begin  -- architecture test

  process is
  begin  -- process

    t <= rotate_left(t, 4);
    assert t = X"23456781" report "left rotate 1 OK!" severity note;
    wait for 1 ns;

    t <= rotate_left(t, 4);
    assert t = X"34567812" report "left rotate 2 OK!" severity note;
    wait for 1 ns;

    t <= rotate_left(t, 4);
    assert t = X"45678123" report "left rotate 3 OK!" severity note;
    wait for 1 ns;

    t <= rotate_left(t, 4);
    assert t = X"56781234" report "left rotate 4 OK!" severity note;
    wait for 1 ns;

    t <= rotate_left(t, 4);
    assert t = X"67812345" report "left rotate 5 OK!" severity note;
    wait for 1 ns;

    ---------------------------------------------------------------------------

    t <= rotate_right(t, 4);
    assert t = X"56781234" report "right rotate 1 OK!" severity note;
    wait for 1 ns;

    t <= rotate_right(t, 4);
    assert t = X"45678123" report "right rotate 2 OK!" severity note;
    wait for 1 ns;

    t <= rotate_right(t, 4);
    assert t = X"34567812" report "right rotate 3 OK!" severity note;
    wait for 1 ns;

    t <= rotate_right(t, 4);
    assert t = X"23456781" report "right rotate 4 OK!" severity note;
    wait for 1 ns;

    t <= rotate_right(t, 4);
    assert t = X"12345678" report "right rotate 5 OK!" severity note;
    wait for 1 ns;

    ---------------------------------------------------------------------------

    t <= X"00000001";

    t <= shift_left(t, 1);
    assert t = X"00000002" report "left shift 1 OK!" severity note;
    wait for 1 ns;

    t <= shift_left(t, 2);
    assert t = X"00000010" report "left shift 2 OK!" severity note;
    wait for 1 ns;

    t <= shift_left(t, 3);
    assert t = X"00000080" report "left shift 3 OK!" severity note;
    wait for 1 ns;

    t <= shift_left(t, 4);
    assert t = X"00000800" report "left shift 4 OK!" severity note;
    wait for 1 ns;

    ---------------------------------------------------------------------------

    t <= shift_right(t, 4);
    assert t = X"00000080" report "right shift 1 OK!" severity note;
    wait for 1 ns;

    t <= shift_right(t, 3);
    assert t = X"00000010" report "right shift 2 OK!" severity note;
    wait for 1 ns;

    t <= shift_right(t, 2);
    assert t = X"00000002" report "right shift 3 OK!" severity note;
    wait for 1 ns;

    t <= shift_right(t, 1);
    assert t = X"00000001" report "right shift 4 OK!" severity note;
    wait for 1 ns;

    wait;
  end process;
  

end architecture test;

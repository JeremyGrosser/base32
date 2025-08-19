--
--  Copyright (C) 2025 Jeremy Grosser <jeremy@synack.me>
--
--  SPDX-License-Identifier: BSD-3-Clause
--
with Ada.Text_IO; use Ada.Text_IO;
with Ada.Streams; use Ada.Streams;
with Base32;

procedure Test is
   function To_SEA
      (Item : String)
      return Stream_Element_Array
   is
      Result : Stream_Element_Array (1 .. Stream_Element_Offset (Item'Length))
         with Import, Address => Item'Address;
   begin
      return Result;
   end To_SEA;

   function To_String
      (Item : Stream_Element_Array)
      return String
   is
      Result : String (1 .. Natural (Item'Length))
         with Import, Address => Item'Address;
   begin
      return Result;
   end To_String;

   Message : constant String := "Hello, base32!";
begin
   Put ('"');
   Put (Message);
   Put ('"');
   New_Line;

   Put ('"');
   Put (Base32.Encode (To_SEA (Message)));
   Put ('"');
   New_Line;

   Put ('"');
   Put (To_String (Base32.Decode (Base32.Encode (To_SEA (Message)))));
   Put ('"');
   New_Line;
end Test;

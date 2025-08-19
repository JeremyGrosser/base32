--
--  Copyright (C) 2025 Jeremy Grosser <jeremy@synack.me>
--
--  SPDX-License-Identifier: BSD-3-Clause
--
pragma Style_Checks ("M120");
with Interfaces; use Interfaces;

package body Base32_Generic is

   type UInt5 is mod 2 ** 5;
   subtype UInt32 is Interfaces.Unsigned_32;

   Digit : constant array (UInt5) of Character :=
      "ABCDEFGHIJKLMNOPQRSTUVWXYZ234567";

   function Encode
      (Item : Element_Array)
      return String
   is
      Length : constant Natural :=
         ((Item'Length * 8 + 4) / 5 + 7) / 8 * 8;
      Output : String (1 .. Length) := (others => '=');
      Value  : UInt32 := 0;
      Bits   : Natural := 0;
      Last   : Natural := 0;
   begin
      for X of Item loop
         Value := Shift_Left (Value, 8) or UInt32 (X);
         Bits := Bits + 8;
         while Bits >= 5 loop
            Last := Last + 1;
            Output (Last) := Digit (UInt5 (Shift_Right (Value, Bits - 5) and 16#1F#));
            Bits := Bits - 5;
         end loop;
      end loop;

      if Bits > 0 then
         Last := Last + 1;
         Output (Last) := Digit (UInt5 (Shift_Left (Value, 5 - Bits) and 16#1F#));
      end if;
      return Output;
   end Encode;

   function Decode_Character
      (Ch : Character)
      return UInt32
   is
   begin
      case Ch is
         when 'a' .. 'z' =>
            return UInt32 (Character'Pos (Ch) - Character'Pos ('a'));
         when 'A' .. 'Z' =>
            return UInt32 (Character'Pos (Ch) - Character'Pos ('A'));
         when '2' .. '7' =>
            return UInt32 (Character'Pos (Ch) - Character'Pos ('2') + 26);
         when others =>
            raise Program_Error with "Not a base32 digit: " & Ch;
      end case;
   end Decode_Character;

   function Decode
      (Item : String)
      return Element_Array
   is
      Length : constant Index := Index (Item'Length * 5 / 8);
      Output : Element_Array (1 .. Length);
      Value  : UInt32 := 0;
      Bits   : Natural := 0;
      Last   : Index := 0;
   begin
      for Ch of Item loop
         exit when Ch = '=';
         Value := Shift_Left (Value, 5) or Decode_Character (Ch);
         Bits := Bits + 5;
         if Bits >= 8 then
            Last := Last + 1;
            Output (Last) := Element (Shift_Right (Value, Bits - 8) and 16#FF#);
            Bits := Bits - 8;
         end if;
      end loop;

      if Bits > 0 and then Value > 0 then
         Last := Last + 1;
         Output (Last) := Element (Shift_Left (Value, 8 - Bits) and 16#FF#);
      end if;
      return Output (1 .. Last);
   end Decode;

end Base32_Generic;

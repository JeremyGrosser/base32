--
--  Copyright (C) 2025 Jeremy Grosser <jeremy@synack.me>
--
--  SPDX-License-Identifier: BSD-3-Clause
--
generic
   type Element is mod <>;
   type Index is range <>;
   type Element_Array is array (Index range <>) of Element;
package Base32_Generic
   with Pure
is
   pragma Compile_Time_Error
      (Element'Modulus /= 256,
       "'Element' type must be 8-bits");

   function Encode
      (Item : Element_Array)
      return String;

   function Decode
      (Item : String)
      return Element_Array;
end Base32_Generic;

--
--  Copyright (C) 2025 Jeremy Grosser <jeremy@synack.me>
--
--  SPDX-License-Identifier: BSD-3-Clause
--
with Base32_Generic;
with Ada.Streams;

package Base32 is new Base32_Generic
   (Element       => Ada.Streams.Stream_Element,
    Index         => Ada.Streams.Stream_Element_Offset,
    Element_Array => Ada.Streams.Stream_Element_Array);

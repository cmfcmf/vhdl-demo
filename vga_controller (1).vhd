--------------------------------------------------------------------------------
--
--   FileName:         vga_controller.vhd
--   Dependencies:     none
--   Design Software:  Quartus II 64-bit Version 12.1 Build 177 SJ Full Version
--
--   HDL CODE IS PROVIDED "AS IS."  DIGI-KEY EXPRESSLY DISCLAIMS ANY
--   WARRANTY OF ANY KIND, WHETHER EXPRESS OR IMPLIED, INCLUDING BUT NOT
--   LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY, FITNESS FOR A
--   PARTICULAR PURPOSE, OR NON-INFRINGEMENT. IN NO EVENT SHALL DIGI-KEY
--   BE LIABLE FOR ANY INCIDENTAL, SPECIAL, INDIRECT OR CONSEQUENTIAL
--   DAMAGES, LOST PROFITS OR LOST DATA, HARM TO YOUR EQUIPMENT, COST OF
--   PROCUREMENT OF SUBSTITUTE GOODS, TECHNOLOGY OR SERVICES, ANY CLAIMS
--   BY THIRD PARTIES (INCLUDING BUT NOT LIMITED TO ANY DEFENSE THEREOF),
--   ANY CLAIMS FOR INDEMNITY OR CONTRIBUTION, OR OTHER SIMILAR COSTS.
--
--   Version History
--   Version 1.0 05/10/2013 Scott Larson
--     Initial Public Release
--    
--------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity vga_module is
  generic(
    h_pulse  :  INTEGER; --horizontal sync pulse width in pixels
    h_bp     :  INTEGER; --horizontal back porch width in pixels
    h_pixels :  INTEGER; --horizontal display width in pixels
    h_fp     :  INTEGER; --horizontal front porch width in pixels
    v_pulse  :  INTEGER; --vertical sync pulse width in rows
    v_bp     :  INTEGER; --vertical back porch width in rows
    v_pixels :  INTEGER; --vertical display width in rows
    v_fp     :  INTEGER);--vertical front porch width in rows
  port(
    pixel_clk :  in   STD_LOGIC;  --pixel clock at frequency of VGA mode being used
    RESET     :  in   STD_LOGIC;  --active high asycnchronous reset
    h_sync    :  out  STD_LOGIC;  --horiztonal sync pulse
    v_sync    :  out  STD_LOGIC;  --vertical sync pulse
    disp_ena  :  out  STD_LOGIC;  --display enable ('1' = display time, '0' = blanking time)
    column    :  out  INTEGER;    --horizontal pixel coordinate
    row       :  out  INTEGER);   --vertical pixel coordinate
end vga_module;

architecture behavior of vga_module is
  constant h_period  :  INTEGER := h_pulse + h_bp + h_pixels + h_fp;  --total number of pixel clocks in a row
  constant v_period  :  INTEGER := v_pulse + v_bp + v_pixels + v_fp;  --total number of rows in column
  signal h_count  :  INTEGER range 0 to h_period - 1 := 0;  --horizontal counter (counts the columns)
  signal v_count  :  INTEGER range 0 to v_period - 1 := 0;  --vertical counter (counts the rows)
begin
  
  controller : process
  begin
    if RESET = '1' then
      h_count <= 0;       
      v_count <= 0; 
      h_sync <= '1';  
      v_sync <= '1';      
      disp_ena <= '0';      
      column <= 0;          
      row <= 0;             
    elsif rising_edge(pixel_clk) then
		-- traverse pixels
      if h_count < h_period - 1 then
        h_count <= h_count + 1;
      else
        h_count <= 0;
        if v_count < v_period - 1 then
          v_count <= v_count + 1;
        else
          v_count <= 0;
        end if;
      end if;

		-- generate sync signals after pixels and front porch are done.
      if h_count >= h_pixels + h_fp and h_count <= h_pixels + h_fp + h_pulse then
        h_sync <= '0';
      else
        h_sync <= '1';
      end if;
      if v_count >= v_pixels + v_fp and v_count <= v_pixels + v_fp + v_pulse then
        v_sync <= '0';
      else
        v_sync <= '1';
      end if;
      
		-- limit column and row to actual pixel range.
      if h_count < h_pixels then
        column <= h_count;
      end if;
      if v_count < v_pixels then
        row <= v_count;
      end if;

		-- enable display when in valid area.
      if h_count < h_pixels and v_count < v_pixels then
        disp_ena <= '1';                               
      else                                           
        disp_ena <= '0';
      end if;
    end if;
  end process;

end behavior;

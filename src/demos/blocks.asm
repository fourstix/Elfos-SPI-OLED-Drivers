;-------------------------------------------------------------------------------
; Display a set of rectangles on an OLED display using the SH1106 controller 
; chip connected to port 0 of the 1802/Mini SPI interface.
;
; Copyright 2023 by Gaston Williams
;
; Based on code from the Elf-Elfos-OLED library
; Written by Tony Hefner
; Copyright 2022 by Tony Hefner
;
; SPI Expansion Board for the 1802/Mini Computer hardware
; Copyright 2022 by Tony Hefner 
;-------------------------------------------------------------------------------
#include ../include/bios.inc
#include ../include/kernel.inc
#include ../include/ops.inc
#include ../include/sh1106.inc
#include ../include/oled.inc
#include ../include/gfx_oled.inc

            org   2000h
start:      br    main


            ; Build information
            ; Build date
date:       db    80h+3          ; Month, 80h offset means extended info
            db    13             ; Day
            dw    2023           ; year
           
            ; Current build number
build:      dw    2              ; build
            db    'Copyright 2023 by Gaston Williams',0


            ; Main code starts here, check provided argument

main:       lda   ra                    ; move past any spaces
            smi   ' '
            lbz   main
            dec   ra                    ; move back to non-space character
            ldn   ra                    ; get byte
            lbz   good                  ; jump if no argument given
            call  o_inmsg               ; otherwise display usage message
            db    'Usage: blocks',10,13,0
            RETURN                      ; and return to os

good:       LOAD  rf, buffer            ; point rf to display buffer
            CALL  clear_buffer          ; clear out buffer
            

            LOAD   r7, $0810             ; draw first block 
            LOAD   r8, $3060             
            CALL   draw_block
            lbdf   error

            LOAD   r7, $1020             ; clear a block inside
            LOAD   r8, $2040             
            CALL   clear_block
            lbdf   error


            LOAD   r7, $1828             ; draw last block
            LOAD   r8, $1030             
            CALL   draw_block
            lbdf   error

            ;---- udpate the display
            ldi   V_OLED_INIT
            CALL  O_VIDEO          
            
            LOAD  rf, buffer
            ldi   V_OLED_SHOW
            CALL  O_VIDEO

done:       CLC   
            RETURN
            
error:      CALL o_inmsg
            db 'Error drawing blocks.',10,13,0
            ABEND                       ; return to Elf/OS with an error code
            
buffer:     ds    BUFFER_SIZE
            end   start

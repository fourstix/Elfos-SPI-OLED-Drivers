;-------------------------------------------------------------------------------
; Display a characters on an OLED display using the SH1106 controller 
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
            ; otherwise display usage message
            call  o_inmsg               
            db    'Usage: charset',10,13,0
            RETURN                      ; Return to Elf/OS

good:       LOAD  rf, buffer            ; point rf to display buffer
            CALL  clear_buffer          ; clear buffer
                  
            ;---- setup the display
            LOAD  rf, buffer            ; point rf to display buffer                        
            ldi   V_OLED_INIT
            CALL  O_VIDEO          


            ldi   96                    ; 96 printable characters
            plo   rc                    ; save in counter
            
            ;---- draw text
            ldi   GFX_BG_TRANSPARENT    ; background shows through
            phi   r9    
          
            LOAD  r7, 0                 ;---- Set R7 at origin (0,0)
            ldi   ' '                   ; set up first character
            plo   r9

            LOAD  rf, buffer            ; point rf to display buffer                        

draw_ch:    glo   rc                    ; get counter
            lbz   show                  ; when done, show display
             
            CALL  draw_char             ; draw character   

            inc   r9                    ; go to next character
            dec   rc                    ; count down
            lbr   draw_ch               ; keep going until all chars drawn
            
show:       LOAD  rf, buffer            ; show updated display
            ldi   V_OLED_SHOW
            CALL  O_VIDEO

            CLC
            RETURN                      ; return to Elf/OS
                      
error:      CALL o_inmsg
            db 'Error drawing character set.',10,13,0
            ABEND                       ; return to Elf/OS with an error code
            
buffer:     ds    BUFFER_SIZE
            end   start

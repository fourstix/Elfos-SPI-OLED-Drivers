;-------------------------------------------------------------------------------
; Display a set of falling snowflake bitmaps on an OLED display using the 
; SH1106 controller chip connected to port 0 of the 1802/Mini SPI interface.
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
            call  O_INMSG               
            db    'Usage: snowflakes',10,13,0
            call  O_INMSG               
            db    'Press input (/EF4) to quit program.',10,13,0
            RETURN                      ; return to Elf/OS

good:       LOAD  rf, buffer            ; point rf to display buffer
            CALL  clear_buffer            ; fill buffer
                  
            ;---- setup the display
            LOAD  rf, buffer            ; point rf to display buffer                        
            ldi   V_OLED_INIT
            CALL  O_VIDEO          
            
repeat:     LOAD  rc, $10               ; set up loop counter            
            LOAD  ra, rand_xy           ; point to random positions

            
            ;----- set up registers for  snowflakes
snowflake:  lda   ra                    ; get random x
            plo   r7                    ; set as x origin
            lda   ra                    ; get random y
            phi   r7                    ; set as y origin
            LOAD  r8, $1010             ; bitmap h = 16, w = 16
  
fall:       LOAD  rf, buffer            ; show updated display                        
            LOAD  rd, flake             ; point to bitmap buffer                         
            CALL  draw_bitmap            ; draw bitmap at random location
            lbdf  error

            LOAD  rf, buffer            ; show updated display
            ldi   V_OLED_SHOW
            CALL  O_VIDEO
            
            ;---- wait half a second (input button will quit)  
            LOAD  rb, $510E             ; wait a quarter of a second
wait1:      bn4   press1
            lbr   done
press1:     dec   rb
            lbrnz rb, wait1

            LOAD  rf, buffer            ; show updated display                        
            LOAD  rd, flake             ; point to bitmap buffer                         
            CALL  clear_bitmap          ; draw bitmap at random location
            lbdf  error

            LOAD  rf, buffer            ; show updated display
            ldi   V_OLED_SHOW
            CALL  O_VIDEO

            ghi   r7                    ; move flake down
            adi   04                    ; 4 pixels
            phi   r7 
            smi   $3F                   ; when we reach the end (63)          
            lbdf  nextflake             ; do the next flake      
            lbr   fall                  ; otherwise keep moving down            
            
nextflake:  dec   rc                    ; count down
            lbrnz rc, snowflake         ; repeat for next snowflake
            lbr   repeat                ; keep going until input is pressed
            
done:       LOAD  rf, buffer            ; point rf to display buffer
            CALL  clear_buffer          ; clear out buffer

            LOAD  rf, buffer
            ldi   V_OLED_SHOW
            CALL  O_VIDEO
             
            RETURN                      ; return to Elf/OS
                      
error:      CALL o_inmsg
            db 'Error drawing bitmap.',10,13,0
            ABEND                       ; return to Elf/OS with an error code
               

;----- snowflake 
flake:    db $01, $00, $03, $80, $01, $00, $C1, $06, $E1, $0E, $19, $30, $07, $C0, $03, $80
          db $07, $C0, $19, $30, $E1, $0E, $C1, $06, $01, $00, $03, $80, $01, $00, $00, $00
          
          ;--- pseudo random cooridinates x = rand(111), y = rand(20) 
          ;   x0  y0  x1   y1   x2  y2  x3  y3  x4  y4   x5  y5 x6   y6  x7  y7 
rand_xy:  db 111,  4, 74,  0,  103, 14, 11,  9, 69,  7,  21,  3, 0,  13,  9, 15
          ;   x8   y8  x9  y9   xA  yA  xB  yB  xC  yC   xD  yD xE   yE  xF  yF 
          db  78,  11, 108, 7,  64,  1, 49,  0,  9,  15, 101, 5, 24, 16, 90, 13  
          
buffer:     ds    BUFFER_SIZE
            end   start

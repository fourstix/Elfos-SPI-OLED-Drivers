;-------------------------------------------------------------------------------
; Display the classic Cosmac Elf Spaceship screen on an OLED display
; connected to the 1802-Mini computer via the SPI Expansion Board.
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
#include ../include/ops.inc
#include ../include/bios.inc
#include ../include/kernel.inc
#include ../include/oled.inc
#include ../include/oled_spi_lib.inc

            org   2000h
start:      br    main


            ; Build information
            ; Build date
date:       db      80h+12         ; Month, 80h offset means extended info
            db      17             ; Day
            dw      2023           ; year
           
            ; Current build number
build:      dw      4              ; build
            db    'Copyright 2023 by Gaston Williams',0


            ; Main code starts here, check provided argument

main:       lda   ra                    ; move past any spaces
            smi   ' '
            lbz   main
            dec   ra                    ; move back to non-space character
            ldn   ra                    ; get byte
            lbz   show                  ; jump if no argument given
            ; otherwise display usage message
            call  O_INMSG               
            db    'Usage: spaceship',10,13,0
            return                      ; Return to Elf/OS

show:       call  oled_check_driver
            lbdf  error
            ldi   V_OLED_INIT
            call  O_VIDEO
            load  rf, spaceship         ; point rf to display buffer
            ldi   V_OLED_SHOW
            call  O_VIDEO
            return                      ; return to Elf/OS
          
error:      abend                       ; return to Elf/OS with error code          
            
spaceship:  db $cf, $cf, $fc, $fc, $fc, $fc, $ff, $ff, $cc, $cc, $00, $00, $00, $00, $00, $00 
          	db $03, $03, $00, $00, $3f, $3f, $cf, $cf, $0c, $0c, $0c, $0c, $3c, $3c, $cf, $cf 
          	db $cf, $cf, $30, $30, $ff, $ff, $f3, $f3, $30, $30, $00, $00, $0f, $0f, $00, $00 
          	db $cf, $cf, $cc, $cc, $ff, $ff, $cf, $cf, $cc, $cc, $00, $00, $33, $33, $03, $03 
          	db $03, $03, $30, $30, $03, $03, $3f, $3f, $00, $00, $03, $03, $30, $30, $0c, $0c 
          	db $ff, $ff, $33, $33, $cf, $cf, $03, $03, $03, $03, $30, $30, $00, $00, $0c, $0c 
          	db $fc, $fc, $3c, $3c, $03, $03, $0c, $0c, $03, $03, $33, $33, $0f, $0f, $0c, $0c 
          	db $f3, $f3, $fc, $fc, $cf, $cf, $0c, $0c, $00, $00, $30, $30, $cf, $cf, $03, $03 
          	db $0f, $0f, $c3, $c3, $3f, $3f, $c0, $c0, $30, $30, $f0, $f0, $33, $33, $30, $30 
          	db $00, $00, $30, $30, $3f, $3f, $cc, $cc, $3c, $3c, $fc, $fc, $00, $00, $00, $00 
          	db $33, $33, $00, $00, $f3, $f3, $cc, $cc, $0c, $0c, $3c, $3c, $0c, $0c, $00, $00 
          	db $03, $03, $03, $03, $ff, $ff, $fc, $fc, $00, $00, $30, $30, $f3, $f3, $f0, $f0 
          	db $00, $00, $00, $00, $33, $33, $30, $30, $0c, $0c, $0c, $0c, $3c, $3c, $3c, $3c 
          	db $0f, $0f, $cc, $cc, $ff, $ff, $30, $30, $f0, $f0, $30, $30, $3c, $3c, $f0, $f0 
          	db $03, $03, $0f, $0f, $ff, $ff, $30, $30, $0c, $0c, $30, $30, $c3, $c3, $fc, $fc 
          	db $00, $00, $f0, $f0, $ff, $ff, $0c, $0c, $fc, $fc, $3c, $3c, $0c, $0c, $cc, $cc 
          	db $00, $00, $f0, $f0, $30, $30, $30, $30, $f0, $f0, $00, $00, $f0, $f0, $30, $30 
          	db $30, $30, $f0, $f0, $00, $00, $f0, $f0, $30, $30, $30, $30, $30, $30, $00, $00 
          	db $f0, $f0, $f0, $f0, $00, $00, $f0, $f0, $f0, $f0, $00, $00, $f0, $f0, $30, $30 
          	db $30, $30, $f0, $f0, $00, $00, $f0, $f0, $30, $30, $30, $30, $f0, $f0, $00, $00 
          	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00 
          	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00 
          	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00 
          	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00 
          	db $00, $00, $3f, $3f, $30, $30, $30, $30, $3c, $3c, $00, $00, $3f, $3f, $30, $30 
          	db $30, $30, $3f, $3f, $00, $00, $33, $33, $33, $33, $33, $33, $3f, $3f, $00, $00 
          	db $3f, $3f, $00, $00, $03, $03, $00, $00, $3f, $3f, $00, $00, $3f, $3f, $03, $03 
          	db $03, $03, $3f, $3f, $00, $00, $3f, $3f, $30, $30, $30, $30, $3c, $3c, $00, $00 
          	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00 
          	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00 
          	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00 
          	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00 
          	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00 
          	db $00, $00, $c0, $c0, $c0, $c0, $c0, $c0, $c0, $c0, $f0, $f0, $f0, $f0, $c0, $c0 
          	db $c0, $c0, $c0, $c0, $c0, $c0, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00 
          	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $f0, $f0 
          	db $0c, $0c, $0c, $0c, $0c, $0c, $0c, $0c, $0c, $0c, $0c, $0c, $0c, $0c, $0c, $0c 
          	db $0c, $0c, $0c, $0c, $0c, $0c, $0c, $0c, $0c, $0c, $0c, $0c, $0c, $0c, $0c, $0c 
          	db $0c, $0c, $0c, $0c, $0c, $0c, $0c, $0c, $0c, $0c, $0f, $0f, $0f, $0f, $0f, $0f 
          	db $0f, $0f, $0f, $0f, $0f, $0f, $0c, $0c, $0c, $0c, $0c, $0c, $cc, $cc, $3c, $3c 
          	db $00, $00, $3f, $3f, $33, $33, $33, $33, $33, $33, $33, $33, $33, $33, $33, $33 
          	db $33, $33, $33, $33, $c0, $c0, $c0, $c0, $cc, $cc, $cc, $cc, $cc, $cc, $cc, $cc 
          	db $c0, $c0, $c0, $c0, $33, $33, $f3, $f3, $33, $33, $33, $33, $33, $33, $33, $33 
          	db $33, $33, $f3, $f3, $33, $33, $0c, $0c, $00, $00, $00, $00, $00, $00, $00, $00 
          	db $03, $03, $03, $03, $03, $03, $03, $03, $03, $03, $ff, $ff, $00, $00, $00, $00 
          	db $ff, $ff, $03, $03, $03, $03, $03, $03, $03, $03, $03, $03, $03, $03, $03, $03 
          	db $03, $03, $03, $03, $03, $03, $03, $03, $03, $03, $03, $03, $03, $03, $03, $03 
          	db $03, $03, $03, $03, $03, $03, $03, $03, $03, $03, $03, $03, $03, $03, $00, $00 
          	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00 
          	db $00, $00, $00, $00, $00, $00, $00, $00, $03, $03, $03, $03, $03, $03, $03, $03 
          	db $00, $00, $00, $00, $c0, $c0, $f0, $f0, $33, $33, $0c, $0c, $0c, $0c, $0c, $0c 
          	db $0c, $0c, $30, $30, $33, $33, $3c, $3c, $30, $30, $30, $30, $30, $30, $30, $30 
          	db $30, $30, $30, $30, $30, $30, $30, $30, $30, $30, $3f, $3f, $00, $00, $00, $00 
          	db $3f, $3f, $30, $30, $30, $30, $f0, $f0, $00, $00, $00, $00, $00, $00, $00, $00 
          	db $00, $00, $ff, $ff, $33, $33, $33, $33, $03, $03, $00, $00, $ff, $ff, $00, $00 
          	db $00, $00, $00, $00, $00, $00, $ff, $ff, $33, $33, $33, $33, $03, $03, $00, $00 
          	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00 
          	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00 
          	db $00, $00, $03, $03, $0f, $0f, $3f, $3f, $30, $30, $c0, $c0, $c3, $c3, $c3, $c3 
          	db $c3, $c3, $c3, $c3, $c3, $c3, $c3, $c3, $33, $33, $33, $33, $30, $30, $30, $30 
          	db $30, $30, $30, $30, $0c, $0c, $0c, $0c, $0c, $0c, $0c, $0c, $0c, $0c, $0c, $0c 
          	db $0c, $0c, $0c, $0c, $0c, $0c, $0f, $0f, $00, $00, $00, $00, $00, $00, $00, $00 
          	db $00, $00, $03, $03, $03, $03, $03, $03, $03, $03, $00, $00, $03, $03, $03, $03 
          	db $03, $03, $03, $03, $00, $00, $03, $03, $00, $00, $00, $00, $00, $00, $00, $00

            end   start

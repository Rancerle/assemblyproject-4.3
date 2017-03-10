; export symbols
            XDEF Entry, _Startup            ; export 'Entry' symbol
            ABSENTRY Entry        ; for absolute assembly: mark this as application entry point



; Include derivative-specific definitions 
		INCLUDE 'derivative.inc'

ROMStart    EQU  $4000  ; absolute address to place my code/constant data

; variable/data section

            ORG RAMStart
 ; Insert here your data definition.
numbers dc.b    $06, $5b, $4f, $66, $6d, $7d, $07, $7f, $67, $3f, $06, $5b, $4f ;1234 thru 0123
display dc.b    $3e, $3d, $3b, $37
numItem dc.b    $0a   ;number of items
numDis  dc.b    $04   ;number of displays
index   dc.b    $00, $00 

; code section
            ORG   ROMStart
Entry:
_Startup:
            lds   #$4000
            movb  #$ff,DDRB   ; initialize displays
            movb  #$3f,DDRP
  
RunDisplay  ldaa  #100        ; Segment timing (2ms)
lope1       staa  index+1
            ldd   #numbers    ; load location of display
            addb  index       ; add the index number
            exg   d,x         ; give x start location
            ldy   #display    
            ldaa  numDis          ;
lope2       movb  1,x+,PORTB  ; write to display
            movb  1,y+,PTP
            jsr   Delay2ms    ; go to sub
            dbne  a,lope2     ; if more displays
            ldaa  index+1
            dbne  a,lope1     ; continue set
            inc   index
            ldaa  index
            cmpa  numItem
            bne   RunDisplay  ; next set
            movb  #0,index
            bra   RunDisplay  ; end of sets          
  
Delay2ms    pshx
            ldx   #1200   ; 2 E cycles
iloop       psha          ; 2 E cycles
            pula          ; 3 E cycles
            psha          ; 2 E cycles
            pula          ; 3 E cycles
            psha          ; 2 E cycles
            pula          ; 3 E cycles
            psha          ; 2 E cycles
            pula          ; 3 E cycles
            psha          ; 2 E cycles
            pula          ; 3 E cycles
            psha          ; 2 E cycles
            pula          ; 3 E cycles
            psha          ; 2 E cycles
            pula          ; 3 E cycles
            nop           ; 1 E cycle
            nop           ; 1 E cycle
            dbne  x,iloop
            pulx
            rts

;**************************************************************
;*                 Interrupt Vectors                          *
;**************************************************************
            ORG   $FFFE
            DC.W  Entry           ; Reset Vector

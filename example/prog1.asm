.vect 000
.vect 000 ;_i_timer_ovf
.vect _i_timer_comp
.vect 000
.vect 000
.vect 000
.vect 000
.vect 000

    clr     $g

;timer configurartion
    movd    $a 00300000
    stsprd  $a %tcmp
    clr     $a
    stsprd  $a %tcnt
    movll   $a 1
    stsprd  $a %tctr
    movll   $a 4
    stsprd  $a %ienb
    clr     $a

;infinity loop
:main_loop
    out $g 
    jmp _main_loop

;timer comparsion interrupt handler
:i_timer_comp 
    addb    $g 1

    clr     $a
    stsprd  $a %tcnt

    iret

;ERASE: b, c
;IN: g(position)
;OUT: a(addr), d(word)
; :get_addr 
;     ;address calculation
;     clr     $c
;     mov     $a $g
;     sar     $a 8
;     mulb    $a 0A
;     movll   $c FF
;     and     $b $g $c
;     sar     $b 2
;     add     $a $a $b    
;     ;offset in word calculation
;     movll   $c 03
;     and     $b $g $c
;     sal     $b 2
;     clr     $d
;     movl    $d F000
;     sa      $d $d $b
;     ret

; :right
;     movl    $a 0027
;     xor     $f $g $a
;     movl    $a 00FF
;     and     $f $f $a
;     jez     _next
;     addb    $g 1
;     jmp     _next

; :left
;     movl    $a 00FF
;     and     $f $g $a
;     jez     _next
;     subb    $g 1
;     jmp     _next

; :down
;     movl    $a FF00
;     and     $f $g $a
;     jez     _next
;     movl    $a 0100
;     sub     $g $g $a
;     jmp     _next   

; :up
;     movl    $a 1D00
;     xor     $f $g $a
;     movl    $a FF00
;     and     $f $f $a
;     jez     _next
;     movl    $a 0100
;     add     $g $g $a
;     jmp     _next   
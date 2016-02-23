.vect 000
.vect 000 ;_i_timer_ovf
.vect _i_timer_comp
.vect 000
.vect 000
.vect 000
.vect 000
.vect 000

;timer configurartion
    movd    $a  00800000
    stsprd  $a  %tcmp
    clr     $a
    stsprd  $a  %tcnt
    movll   $a  1
    stsprd  $a  %tctr
    movll   $a  4
    stsprd  $a  %ienb
    clr     $a

;setup
    clr     $g
    clr     $b
    movd    $h  00000800
    movd    $e  00000805

    movd    $a  000007FF    ;direction
    movll   $b  04
    straml  $b  $a

    subb    $a  1           ;food position at 0x000007FE
    movl    $g  1020
    straml  $g  $a          
    call    _get_addr
    movl    $b  AAAA
    and     $d  $d  $b
    straml  $d  $a

    subb    $a  1           ;score at 0x000007FD
    clr     $b
    straml  $b  $a  

    movd    $a  00000800
    movl    $b  0F0E
    straml  $b  $a
    addb    $a  1
    movl    $b  100E
    straml  $b  $a
    addb    $a  1
    movl    $b  100F
    straml  $b  $a
    addb    $a  1
    movl    $b  1010
    straml  $b  $a
    addb    $a  1
    movl    $b  1011
    straml  $b  $a

    movd    $a  00010000

;infinity loop
:main_loop
    jmp     _main_loop

;timer comparsion interrupt handler
:i_timer_comp 
    movd    $f  00000800
    xor     $f  $f  $h
    ldraml  $c  $h
    jnz     _l0
    mov     $h  $e 
:l0
    subb    $h  1
    ldraml  $g  $h
    mov     $f  $c
    call    _get_addr
    ldraml  $b  $a
    not     $d  $d
    and     $d  $d  $b
    straml  $d  $a
    mov     $g  $f

    movd    $c  000007FF
    ldraml  $b  $c

    clr     $d
    movll   $d  0F
    in      $a
    and     $a  $a  $d

    clr     $f
    movll   $f  01
    xor     $f  $f  $b
    jez     _go_right
    movll   $f  02
    xor     $f  $f  $b
    jez     _go_down
    movll   $f  04
    xor     $f  $f  $b
    jez     _go_up
    movll   $f  08
    xor     $f  $f  $b
    jez     _go_left
    movll   $a  AA
:next
    movd    $c  000007FF
    straml  $a  $c
    straml  $g  $h  
    out     $g

    movd    $c  000007FE
    clr     $f
    ldraml  $f  $c
    xor     $f  $f  $g
    jnz     _food_remains
    movd    $c  000007FD
    ldraml  $b  $c
    addb    $b  1
    straml  $b  $c
:gen_food_again
    in      $g
    shr     $g  10

    movd    $f  00000800
    xor     $f  $f  $e
:next_part2
    xor     $f  $f  $e
    ldraml  $a  $f
    mov     $b  $f
    xor     $f  $g  $a
    jez     _gen_food_again
    mov     $f  $b
    addb    $f  1
    xor     $f  $f  $e
    jnz     _next_part2

    movd    $c  000007FE
    straml  $g  $c
    call    _get_addr
    ldraml  $b  $a
    or      $d  $d  $b
    straml  $d  $a

:food_remains

;snake to video
    movd    $f  00000800
    xor     $f  $f  $e
:next_part
    xor     $f  $f  $e
    ldraml  $g  $f
    call    _get_addr
    ldraml  $b  $a
    or      $d  $d  $b
    straml  $d  $a
    addb    $f  1
    xor     $f  $f  $e
    jnz     _next_part  

    clr     $d
    stsprd  $d  %tcnt

    iret

;ERASE: b, c
;IN: g(position), d(color)
;OUT: a(addr), d(word)
:get_addr 
    ;address calculation
    clr     $c
    mov     $a  $g
    shr     $a  8
    mulb    $a  0A
    movll   $c  FF
    and     $b  $g  $c
    shr     $b  2
    add     $a  $a  $b    
    ;offset in word calculation
    movll   $c  03
    and     $b  $g  $c
    shl     $b  2
    clr     $d
    movlh   $d  F0
    sh      $d  $d  $b
    movh    $a  0001
    ret

:go_right
    movll   $d  04
    xor     $f  $a  $d
    jez     _right_gap
    movll   $d  02
    xor     $f  $a  $d
    jez     _right_gap
    movll   $d  01
    xor     $f  $a  $d
    jez     _right_gap
    movll   $a  01
:right_gap
    movl    $c  0027
    xor     $f  $g  $c
    movl    $c  00FF
    and     $f  $f  $c
    jez     _right_ovf
    addb    $g  1
    jmp     _next
:right_ovf
    movll   $g  00
    jmp     _next

:go_left
    movll   $d  08
    xor     $f  $a  $d
    jez     _left_gap
    movll   $d  04
    xor     $f  $a  $d
    jez     _left_gap
    movll   $d  02
    xor     $f  $a  $d
    jez     _left_gap
    movll   $a  08
:left_gap
    movl    $c  00FF
    and     $f  $g $c
    jez     _left_ovf
    subb    $g  1
    jmp     _next
:left_ovf
    movll   $g  27
    jmp     _next

:go_up
    movll   $d  08
    xor     $f  $a  $d
    jez     _up_gap
    movll   $d  04
    xor     $f  $a  $d
    jez     _up_gap
    movll   $d  01
    xor     $f  $a  $d
    jez     _up_gap
    movll   $a  04
:up_gap
    movl    $c FF00
    and     $f $g $c
    jez     _up_ovf
    movl    $c 0100
    sub     $g $g $c
    jmp     _next   
:up_ovf
    movlh   $g  1D
    jmp     _next

:go_down
    movll   $d  08
    xor     $f  $a  $d
    jez     _down_gap
    movll   $d  02
    xor     $f  $a  $d
    jez     _down_gap
    movll   $d  01
    xor     $f  $a  $d
    jez     _down_gap
    movll   $a  02
:down_gap
    movl    $c 1D00
    xor     $f $g $c
    movl    $c FF00
    and     $f $f $c
    jez     _down_ovf
    movl    $c 0100
    add     $g $g $c
    jmp     _next   
:down_ovf
    movlh   $g  00
    jmp     _next
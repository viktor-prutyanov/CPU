.vect 000
.vect 000 ;_i_timer_ovf
.vect _i_timer_comp
.vect 000
.vect 000
.vect 000
.vect 000
.vect 000

;timer configurartion
    movd    $a  00300000
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
        
    movd    $a  000007FF
    movll   $b  10
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
    and     $d  $d $b
    straml  $d  $a
    mov     $g  $f

    movd    $c  000007FF
    ldraml  $b  $c
    clr     $f
    clr     $c

    movl    $f  0000
    xor     $f  $f  $b
    jez     _go_right
    movl    $f  0001
    xor     $f  $f  $b
    jez     _go_down
    movl    $f  0010
    xor     $f  $f  $b
    jez     _go_up
    movl    $f  0011
    xor     $f  $f  $b
    jez     _go_left

:next
    straml  $g  $h   

;change direction
    in      $a
    clr     $b
    movll   $b 01
    and     $f $a $b
    jnz     _right_left
    sal     $b 1
    and     $f $a $b
    jnz     _up_down
    sal     $b 1
    and     $f $a $b
    jnz     _up_down
    sal     $b 1
    and     $f $a $b
    jnz     _right_left
:next2
    

;snake output
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
;IN: g(position)
;OUT: a(addr), d(word)
:get_addr 
    ;address calculation
    clr     $c
    mov     $a  $g
    sar     $a  8
    mulb    $a  0A
    movll   $c  FF
    and     $b  $g  $c
    sar     $b  2
    add     $a  $a  $b    
    ;offset in word calculation
    movll   $c  03
    and     $b  $g  $c
    sal     $b  2
    clr     $d
    movl    $d  F000
    sa      $d  $d  $b
    movh    $a  0001
    ret

:go_right
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
    movl    $c  00FF
    and     $f  $g $c
    jez     _left_ovf
    subb    $g  1
    jmp     _next
:left_ovf
    movll   $g  27
    jmp     _next

:go_up
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


:right_left
    movd    $c  000007FF
    ldraml  $d  $c
    clr     $a
    movll   $a  01
    xor     $f  $d  $a
    jnz     _l1
    straml  $a  $c   
:l1
    movll   $a  10
    xor     $f  $d  $a
    jnz     _next2
    straml  $a  $c 
    jmp     _next2

:up_down
    movd    $c  000007FF
    ldraml  $d  $c
    clr     $a
    xor     $f  $d  $a
    jnz     _l2
    straml  $a  $c  
:l2
    movll   $a  11
    xor     $f  $d  $a
    jnz     _next2
    straml  $a  $c 
    jmp     _next2  
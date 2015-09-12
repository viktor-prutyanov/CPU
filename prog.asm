.vect 000
.vect 000 ;_i_timer_ovf
.vect _i_timer_comp
.vect 000
.vect 000
.vect 000
.vect 000
.vect 000

    movd $a 00000200 ;base address for local variables
    movd $f 0000000C ;12
    clr $c

    call _factorial
    clr $a
    clr $c

;timer configurartion
    movd    $a 02DC6C00 ;48000000 
    stsprd  $a %tcmp
    clr     $a
    stsprd  $a %tcnt
    movll   $a 1
    stsprd  $a %tctr
    movll   $a 4
    stsprd  $a %ienb

;infinity loop
:main_loop
    out     $f
    jmp _main_loop

;timer comparsion interrupt
:i_timer_comp
    rol     $f 10
    clr     $a
    stsprd  $a %tcnt
    iret

;factorial function
:factorial
    jez     _zero
    stramh  $f $a
    addb    $a 1
    straml  $f $a
    addb    $a 1
    subb    $f 1
    call    _factorial
    subb    $a 1
    ldraml  $c $a
    subb    $a 1
    ldramh  $c $a
    mul     $f $f $c
    ret
:zero
    movd $f 00000001
    ret
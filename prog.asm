.vect 000
.vect 000 ;_i_timer_ovf
.vect _i_timer_comp ;label address immediately writes to top of memory by 'vect'
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

;timer configuration
    movd    $a 02DC6C00 ;48000000 tics (frecuency = 48MHz)
    stsprd  $a %tcmp ;stsprd means STore Special Purpose Register
    clr     $a ;tcmp - compare regiser
    stsprd  $a %tcnt ; - counter
    movll   $a 1
    stsprd  $a %tctr ; - control register
    movll   $a 4
    stsprd  $a %ienb ; - interrupts enable mask

;infinity loop
:main_loop
    out     $f
    jmp _main_loop

;timer comparsion interrupt
:i_timer_comp
    rol     $f 10 ; - rotate left (12! needs 8 hex digits, but indicator only has 4)
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

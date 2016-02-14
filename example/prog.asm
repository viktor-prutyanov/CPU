.vect 000
.vect 000
.vect 000
.vect 000
.vect 000
.vect 000
.vect 000
.vect 000

    movd $b DEADBEEF
    movd $a 00000004
    movd $g 00010004
    straml $b $a
    stramh $b $g
    ldraml $c $g

:main_loop
    out $c
    jmp _main_loop
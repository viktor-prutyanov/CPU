.vect 000
.vect 000 ;_i_timer_ovf
.vect _i_timer_comp
.vect 000
.vect 000
.vect 000
.vect 000
.vect 000

;timer configurartion
movd $a 02DC6C00 ;48000000 
stsprd $a %tcmp
clr $a
stsprd $a %tcnt
movll $a 1
stsprd $a %tctr
movll $a 4
stsprd $a %ienb

clr $a
clr $b

movll $f 1
:main_loop
out $b
jnz _main_loop

:i_timer_comp
addb $b 1
stsprd $a %tcnt
iret
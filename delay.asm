xor $a $a $a
mov0 $a 17
out $a
xor $b $b $b
mov0 $b 255
xor $f $f $f
:loop0
addb $f 1
jnz _loop0
out $b
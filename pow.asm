xor $b $b $b
mov0 $b 3
xor $f $f $f
mov0 $f 4         
mov $c $b
subb $f 1
:pow
subb $f 1
mul $b $b $c
jnz _pow
out $b
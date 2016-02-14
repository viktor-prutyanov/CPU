xor $d $d $d
mov0 $d A1
mov2 $d B2
xor $a $a $a
mov0 $a FE
xor $b $b $b
mov0 $b FF
ldil $d $a
ldih $d $b
addb $a 1
subb $b 1
ldol $c $a
ldoh $c $b
out $c
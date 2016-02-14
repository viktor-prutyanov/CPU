xor $a $a $a
mov0 $a AA 
mov1 $a BB
mov2 $a CC
mov3 $a DD
pushl $a
pushh $a
mov0 $a 11 
mov1 $a 22
mov2 $a 33
mov3 $a 44
pushl $a
pushh $a
mov0 $c FF
mov1 $c FF
mov2 $c FF
mov3 $c FF
ldol $b $c
subb $c 3
ldoh $b $c
out $b
xor $a $a $a
mov3 $a 01
mov2 $a 23
mov1 $a 45
mov0 $a 67 
pushl $a
pushh $a
mov3 $a 89
mov2 $a AB
mov1 $a CD
mov0 $a EF
pushl $a 
pushh $a
poph $d
popl $d
poph $c
popl $c
out $d
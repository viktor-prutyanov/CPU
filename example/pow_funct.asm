movd $b 3
movd $e 6
call _pow
out $a
end
;$b = base, $e = exp, $a = result
:pow
    mov $a $b
    mov $f $e
    subb $f 1
    :pow_loop 
        subb $f 1
        mul $a $a $b
    jnz _pow_loop
ret
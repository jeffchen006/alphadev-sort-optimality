# n=5 model=out iset=I1 prefix14_class=3942
mov S0, P3
cmp P1, S0
cmovl P3, P1
cmovg S0, P1
mov P1, P2
cmp P1, P0
cmovle P2, P0
cmovle P0, P1
mov P1, P0
cmp P3, P1
cmovg P0, P3
cmovl P1, P3
cmp P2, S0
mov P3, P2

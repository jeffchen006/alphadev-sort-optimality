# n=5 model=out iset=I1 prefix14_class=4199
cmp P3, P0
mov S0, P0
cmovg S0, P3
cmovg P3, P0
cmovle P0, P3
mov S1, P2
cmp S1, P1
cmovl P2, P1
cmovl P1, S1
cmp P1, P3
cmovl P3, P1
cmovge P0, P1
mov P3, S0
mov P1, P0

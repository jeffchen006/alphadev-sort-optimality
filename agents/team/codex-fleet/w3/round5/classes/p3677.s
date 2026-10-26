# n=5 model=out iset=I1 prefix14_class=3677
cmp P0, P3
mov S1, P3
cmovg S1, P0
cmovle P3, P0
mov S0, P2
cmp P2, P1
cmovl S0, P1
mov P0, P3
cmovle P1, P2
cmp P0, P1
cmovl P0, P1
cmovl P1, P3
cmp S1, S0
cmovge P3, S0

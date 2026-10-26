# n=5 model=out iset=I1 prefix14_class=422
mov S1, P0
cmp P1, P0
cmovle P0, P1
cmovg S1, P1
mov S0, P2
cmp S0, P3
cmovg P2, P3
cmovge P3, S0
mov S0, P2
cmp P0, P2
cmovl S0, P0
cmovl P0, P2
cmp S1, P3
cmovge P2, P3

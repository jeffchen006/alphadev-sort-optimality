# n=5 model=out iset=I1 prefix14_class=3410
mov S1, P3
cmp P2, P3
mov S0, P0
cmovl S1, P2
cmovge P3, P2
cmp P0, P1
cmovl S0, P1
cmovle P1, P0
mov P0, P1
cmp S1, P0
cmovg P0, S1
cmovl P1, S1
cmp S0, P3
cmovg S2, P3

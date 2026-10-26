# n=5 model=out iset=I1 prefix14_class=7560
mov S1, P2
cmp P2, P1
mov S0, P3
cmovle P2, P1
cmovg S1, P1
mov P1, S1
cmp P0, S0
cmovg S0, P0
cmovge P0, P3
cmp S1, P0
cmovle P1, P0
cmovl P0, S1
cmp P2, S0
cmovl S2, S0

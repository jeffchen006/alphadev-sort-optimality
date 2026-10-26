# n=5 model=out iset=I1 prefix14_class=185
cmp P1, P2
cmovl S2, P2
cmovge S2, P1
cmovge P1, P2
mov P2, P0
cmp P3, P0
cmovle P0, P3
cmovle P3, P2
mov S0, S2
mov S1, P1
cmp P0, P1
cmovg S1, P0
cmovl P1, P0
cmp S2, P3

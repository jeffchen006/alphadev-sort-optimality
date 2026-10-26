# n=5 model=out iset=I1 prefix14_class=3209
mov S1, P0
cmp P1, P0
mov S0, P2
cmovle P0, P1
cmovge S1, P1
cmp P3, P2
cmovge P2, P3
cmovl S0, P3
mov P3, S0
cmp P0, P3
cmovg S0, P0
cmovg P0, P3
cmp S1, P2
cmovl P1, P2

# n=5 model=out iset=I1 prefix14_class=10380
mov S1, P2
cmp P3, P0
cmovl S0, P3
cmovle P3, P0
cmovl P0, S0
cmp S1, P1
cmovg S1, P1
cmovle P2, P1
cmp P3, P2
cmovge S0, P3
mov P1, P0
cmovg P3, P2
cmovge P2, S0
cmp P0, S1

# n=5 model=out iset=I1 prefix14_class=5063
cmp P0, P2
cmovle S1, P2
cmovg S1, P0
mov S0, P1
cmovle P2, P0
cmp P3, S0
cmovl S0, P3
cmovg P1, P3
mov P0, P2
cmp P0, S0
cmovge P0, S0
cmovl P2, S0
cmp P1, S1
cmovge S2, S1

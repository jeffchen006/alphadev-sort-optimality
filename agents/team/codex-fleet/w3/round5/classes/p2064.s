# n=5 model=out iset=I1 prefix14_class=2064
cmp P3, P1
cmovle S0, P1
cmovge S0, P3
cmovle P1, P3
mov S1, P2
cmp P2, P0
cmovg P2, P0
cmovg P0, S1
cmp P0, S0
cmovl S2, P0
cmovge S2, S0
cmovl P0, S0
mov S1, S2
mov P0, P2

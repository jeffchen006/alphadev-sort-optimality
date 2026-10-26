# n=5 model=out iset=I1 prefix14_class=12853
cmp P1, P3
cmovle S0, P1
cmovge S0, P3
cmovle P1, P3
cmp P0, P2
mov S2, P0
cmovl S2, P2
cmovg P0, P2
mov S1, P0
cmp P0, S0
cmovge S1, S0
cmovge S0, P0
cmp P1, S2
cmovl P0, P1

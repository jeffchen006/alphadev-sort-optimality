# n=5 model=out iset=I1 prefix14_class=8793
cmp P1, P2
cmovl S1, P1
mov S0, P3
cmovle P1, P2
cmovge S1, P2
cmp P0, P3
cmovge S0, P0
cmovle P3, P0
cmp P1, S0
cmovge S2, P1
cmovg P1, S0
cmovge S0, S2
mov P0, P3
cmp P0, S1

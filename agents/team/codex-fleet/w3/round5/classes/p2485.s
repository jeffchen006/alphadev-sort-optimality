# n=5 model=out iset=I1 prefix14_class=2485
cmp P1, P3
cmovl S1, P1
cmovge S1, P3
cmovle P1, P3
cmp P2, P0
mov S0, P0
cmovge P0, P2
mov S2, P1
cmovg P2, S0
cmp P1, P0
cmovle P1, P0
cmovle P0, S2
cmp P2, S1
cmovg S0, P2

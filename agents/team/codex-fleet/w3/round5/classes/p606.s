# n=5 model=out iset=I1 prefix14_class=606
mov S1, P0
mov S2, P3
cmp S2, P1
cmovg P3, P1
cmovle S2, P1
cmp P0, P2
cmovg P0, P2
cmovg P2, S1
cmp P2, S2
cmovl S0, P2
cmovge S0, S2
cmovg S2, P2
cmp P3, P0
cmovle P1, P0

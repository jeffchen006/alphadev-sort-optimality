# n=5 model=out iset=I1 prefix14_class=8401
cmp P3, P0
mov S1, P0
cmovle P0, P3
cmovge S1, P3
cmp P1, P2
mov S0, S1
cmovle S2, P2
cmovg S2, P1
cmovg P1, P2
cmp S0, S2
cmovl S0, S2
cmovge S1, S2
cmp P1, P0
cmovle S2, P0

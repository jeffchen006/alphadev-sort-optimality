# n=5 model=out iset=I1 prefix14_class=8837
cmp P0, P1
cmovge S2, P0
cmovg P0, P1
mov S1, P3
cmovl S2, P1
cmp P2, S1
cmovg S1, P2
cmovle P3, P2
mov S0, S1
cmp S0, S2
cmovge S0, S2
cmovg S2, S1
cmp P3, P0
cmovle S2, P3

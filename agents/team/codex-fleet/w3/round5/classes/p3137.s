# n=5 model=out iset=I1 prefix14_class=3137
mov S2, P2
cmp P1, P0
mov S1, P0
cmovg P0, P1
cmovl S1, P1
mov S0, S1
cmp P3, S2
cmovge S2, P3
cmovle P2, P3
cmp S0, P2
cmovg S0, P2
cmovle S1, P2
cmp S2, P0
cmovg P1, P0

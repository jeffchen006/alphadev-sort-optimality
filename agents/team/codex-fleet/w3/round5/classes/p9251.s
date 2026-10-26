# n=5 model=out iset=I1 prefix14_class=9251
mov S1, P3
cmp P3, P0
cmovg S1, P0
mov S0, S1
cmovg P0, P3
cmp P1, P2
cmovge S2, P1
cmovg P1, P2
cmovg P2, S2
cmp S1, P1
cmovg S1, P1
cmovle S0, P1
cmp P0, P2
cmovl S2, P0

# n=5 model=out iset=I1 prefix14_class=9203
cmp P2, P1
mov S1, P0
cmovle S2, P1
cmovge S2, P2
cmovg P2, P1
mov S0, P2
cmp P3, S1
cmovl S1, P3
cmovg P0, P3
cmp S1, S0
cmovg P2, S1
cmovl S0, S1
cmp P0, S2
cmovg S1, S2

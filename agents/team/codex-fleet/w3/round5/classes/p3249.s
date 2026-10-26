# n=5 model=out iset=I1 prefix14_class=3249
mov S0, P0
cmp P2, P0
cmovg P0, P2
cmovge P2, S0
mov S0, P2
cmp P1, P3
cmovg S1, P1
cmovle S1, P3
cmovg P1, P3
cmp S0, P1
cmovl S0, P1
cmovg P2, P1
cmp P0, S1
cmovge S2, S1

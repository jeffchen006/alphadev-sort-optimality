# n=5 model=out iset=I1 prefix14_class=14206
cmp P2, P3
mov S2, P1
cmovg S0, P2
cmovle S0, P3
cmovg P2, P3
cmp P0, S2
cmovge S2, P0
cmovge P0, P1
cmp S2, S0
mov S1, S2
cmovl S1, S0
cmovg S2, S0
mov S0, S2
mov S1, P0

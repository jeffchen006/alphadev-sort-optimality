# n=5 model=out iset=I1 prefix14_class=492
mov S1, P0
cmp P3, P0
cmovge P0, P3
mov S0, P1
cmovl S1, P3
cmp P1, P2
cmovg S0, P2
cmovg P2, P1
cmp S1, S0
mov S2, S0
cmovle S0, S1
cmovle S1, S2
cmp P0, P2
cmovge P3, P0

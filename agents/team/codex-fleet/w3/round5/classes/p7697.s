# n=5 model=out iset=I1 prefix14_class=7697
cmp P3, P2
mov S1, P3
cmovg S1, P2
cmovge P2, P3
cmp P1, P0
cmovle S2, P1
cmovg S2, P0
cmovge P0, P1
cmp S2, S1
mov S0, S2
cmovg S2, S1
cmovl S0, S1
cmp P0, P2
cmovg S2, P0

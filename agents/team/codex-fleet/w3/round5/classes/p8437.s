# n=5 model=out iset=I1 prefix14_class=8437
mov S1, P3
mov S2, P2
cmp P3, P1
cmovge P3, P1
cmovle S1, P1
cmp P0, P2
cmovg S2, P0
cmovge P0, P2
mov S0, S2
cmp S1, S0
cmovg S2, S1
cmovge S1, S0
cmp P0, P3
cmovl S0, P0

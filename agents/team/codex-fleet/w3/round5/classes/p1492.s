# n=5 model=out iset=I1 prefix14_class=1492
mov S0, P0
mov S2, P3
cmp P3, P1
cmovl S2, P1
cmovge P3, P1
cmp S0, P2
cmovle S0, P2
cmovl P2, P0
cmp S0, S2
cmovge P0, S2
cmovg S2, S0
mov S1, P3
cmovge S0, P0
cmp P2, P3

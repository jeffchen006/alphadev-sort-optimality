# n=5 model=out iset=I1 prefix14_class=9450
cmp P0, P1
cmovge S1, P1
mov S0, P3
cmovl S1, P0
cmovl P0, P1
cmp P3, P2
cmovge P3, P2
cmovle S0, P2
mov S2, P3
cmp S1, S2
cmovl P3, S1
cmovg S2, S1
cmp S0, P0
cmovge P1, P0

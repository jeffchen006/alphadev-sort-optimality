# n=5 model=out iset=I1 prefix14_class=8049
mov S1, P3
cmp P2, P0
mov S2, P0
cmovg S2, P2
cmovl P0, P2
cmovge P2, P0
cmp S1, P1
cmovg P3, P1
cmovle S1, P1
cmp P0, P3
cmovg P2, P3
cmovl P0, P3
cmp S2, S1
cmovge S0, S2

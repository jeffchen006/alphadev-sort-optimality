# n=5 model=out iset=I1 prefix14_class=8654
cmp P2, P0
cmovg S2, P2
cmovle S2, P0
mov S1, P1
cmovge P2, P0
cmp P3, P1
cmovle S1, P3
cmovl P3, P1
cmp S2, P3
cmovle S0, P3
cmovge S0, S2
cmovg S2, P3
cmp P2, S1
cmovl S0, S1

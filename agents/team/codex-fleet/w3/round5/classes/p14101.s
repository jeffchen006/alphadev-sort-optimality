# n=5 model=out iset=I1 prefix14_class=14101
mov S2, P1
cmp P0, S2
cmovge P1, P0
cmovge P0, S2
cmp P3, P2
cmovg S1, P3
mov S0, P1
cmovle S1, P2
cmovg P3, P2
cmp S1, S0
cmovl P1, S1
cmovl S1, S0
cmp P0, P3
cmovle S2, P3

# n=5 model=out iset=I1 prefix14_class=8833
cmp P3, P1
cmovg S0, P3
cmovge P3, P1
cmovle S0, P1
mov P1, P0
cmp P2, P1
cmovl P0, P2
cmovg P1, P2
cmp P1, S0
cmovge S1, P1
cmovg P1, S0
cmovg S0, S1
cmp P0, P3
cmovg S2, P0

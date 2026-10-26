# n=5 model=out iset=I1 prefix14_class=9819
cmp P3, P0
cmovge S1, P3
cmovge P3, P0
cmovle S1, P0
cmp P1, P2
cmovle S2, P2
mov P0, S1
cmovl P2, P1
cmovl P1, S2
cmp P1, P0
cmovg S1, P1
cmovg P1, P0
cmp P2, P3
cmovge S0, P2

# n=5 model=out iset=I1 prefix14_class=12073
cmp P0, P1
cmovl S1, P0
cmovl P0, P1
cmovge S1, P1
cmp P2, P3
cmovge S2, P3
cmovge P3, P2
cmovg P2, S2
mov P1, S1
cmp P2, S1
cmovl P1, P2
cmovg S1, P2
cmp P3, P0
cmovle S0, P0

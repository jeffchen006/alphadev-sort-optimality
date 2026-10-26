# n=5 model=out iset=I1 prefix14_class=7673
cmp P0, P1
cmovl S1, P0
cmovge S1, P1
cmovl P0, P1
cmp P2, P3
cmovg S2, P3
mov S0, S1
cmovg P3, P2
cmovg P2, S2
cmp P2, S0
mov P1, P3
cmovg S0, P2
cmovle S1, P2
cmp P3, P0

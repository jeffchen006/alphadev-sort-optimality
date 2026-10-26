# n=5 model=out iset=I1 prefix14_class=7500
mov S2, P0
cmp P1, P3
cmovg S0, P1
cmovg P1, P3
cmovg P3, S0
cmp P0, P2
cmovge P0, P2
cmovle S2, P2
cmp P1, P0
cmovl S1, P0
cmovl P0, P1
cmovge S1, P1
cmp P3, S2
mov P0, S2

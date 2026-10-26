# n=5 model=out iset=I1 prefix14_class=6810
cmp P2, P1
cmovle S2, P1
cmovl P1, P2
cmovge S2, P2
mov P2, S2
mov S1, P1
cmp P3, P0
cmovg S0, P0
cmovge P0, P3
cmovg P3, S0
cmp P0, S2
cmovl S2, P0
cmovg P2, P0
cmp P3, S1

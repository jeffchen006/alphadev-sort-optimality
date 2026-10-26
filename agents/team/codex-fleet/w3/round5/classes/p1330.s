# n=5 model=out iset=I1 prefix14_class=1330
cmp P3, P1
cmovge S1, P3
cmovl S1, P1
cmovl P1, P3
mov S2, P0
cmp P0, P2
mov P3, S1
cmovge S2, P2
cmovge P2, P0
cmp P2, S1
cmovge P3, P2
cmovle S1, P2
cmp P1, S2
cmovg S0, S2

# n=5 model=out iset=I1 prefix14_class=7953
cmp P3, P1
cmovle S2, P1
cmovge S2, P3
mov S1, P0
cmovg P3, P1
cmp P0, P2
cmovg S1, P2
cmovge P2, P0
cmp P3, S1
cmovge P1, S1
cmovge S1, P3
cmovg P3, P1
cmp P2, S2
cmovl S0, P2

# n=5 model=out iset=I1 prefix14_class=3739
mov S0, P0
cmp P2, S0
cmovle S0, P2
cmovl P2, P0
cmovge P0, P2
cmp P3, P1
mov S2, S0
cmovge S1, P1
cmovg P1, P3
cmovg P3, S1
cmp P3, S2
cmovge S0, P3
cmovl S2, P3
cmp P0, P1

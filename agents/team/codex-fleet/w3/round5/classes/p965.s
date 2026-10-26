# n=5 model=out iset=I1 prefix14_class=965
cmp P1, P2
cmovle S0, P2
cmovl P2, P1
cmovg S0, P1
cmp P0, P3
mov S1, S0
cmovg S2, P0
cmovge P0, P3
cmovg P3, S2
cmp P3, S1
cmovge S0, P3
cmovg P3, S1
cmp P0, P2
cmovge S1, P2

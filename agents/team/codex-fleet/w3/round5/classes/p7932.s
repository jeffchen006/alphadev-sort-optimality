# n=5 model=out iset=I1 prefix14_class=7932
cmp P0, P1
cmovle S0, P1
cmovge S0, P0
cmovl P1, P0
cmp P3, P2
cmovge S1, P2
cmovl S1, P3
cmovg P2, P3
cmp P1, S1
mov S2, P2
cmovge P3, S1
cmovge S1, P1
cmovg P1, P3
cmp P2, S0

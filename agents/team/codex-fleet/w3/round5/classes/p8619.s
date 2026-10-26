# n=5 model=out iset=I1 prefix14_class=8619
mov S2, P3
cmp P2, P3
cmovl P3, P2
cmovge S2, P2
cmp P1, P0
cmovg S1, P1
cmovg P1, P0
cmovg P0, S1
mov S0, P3
cmp P0, S2
cmovge S1, S2
cmovg S2, P0
cmovge P0, S1
cmp P3, P1

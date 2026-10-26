# n=5 model=out iset=I1 prefix14_class=4100
mov S0, P2
cmp P3, P2
cmovl P2, P3
mov S1, P0
cmovg S0, P3
cmp P1, S1
cmovge P0, P1
cmovge P1, S1
cmp P2, P1
cmovge S2, P1
cmovg P1, P2
cmovg P2, S2
cmp P0, S0
mov S1, S0

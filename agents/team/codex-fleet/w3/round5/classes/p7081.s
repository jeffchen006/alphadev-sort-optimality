# n=5 model=out iset=I1 prefix14_class=7081
mov S1, P1
cmp P3, S1
cmovg S1, P3
cmovge P3, P1
cmp P0, P2
cmovg S0, P0
cmovge P0, P2
mov P1, P3
cmovg P2, S0
cmp P0, P1
cmovg P3, P0
cmovl P1, P0
mov S2, P2
cmp P2, S1

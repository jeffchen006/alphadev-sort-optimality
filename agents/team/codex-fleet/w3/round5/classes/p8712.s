# n=5 model=out iset=I1 prefix14_class=8712
cmp P0, P2
cmovge S0, P2
cmovg P2, P0
cmovg P0, S0
mov S1, P3
mov S2, P2
cmp P3, P1
cmovg S1, P1
cmovl P3, P1
cmp P3, S2
cmovg S2, P3
mov S2, S1
cmovl P2, P3
cmovge P3, P2

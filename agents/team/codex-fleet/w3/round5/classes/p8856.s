# n=5 model=out iset=I1 prefix14_class=8856
mov S0, P0
mov S2, P3
cmp P3, P2
cmovl S2, P2
cmovge P3, P2
cmp P0, P1
cmovg S0, P1
cmovg P1, P0
cmp P1, S2
cmovge S1, S2
cmovg S2, P1
mov P2, P3
cmovge P1, S1
cmp P3, S0

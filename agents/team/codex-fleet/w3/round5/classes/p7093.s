# n=5 model=out iset=I1 prefix14_class=7093
mov S0, P0
cmp P2, S0
cmovg S0, P2
mov S1, P1
cmovge P2, P0
cmp P1, P3
mov S2, P2
cmovg P1, P3
cmovg P3, S1
cmp P1, P2
cmovl P2, P1
cmovge S2, P1
mov P0, S2
mov P2, S0

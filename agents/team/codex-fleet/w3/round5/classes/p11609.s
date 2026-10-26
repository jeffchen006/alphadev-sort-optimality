# n=5 model=out iset=I1 prefix14_class=11609
mov S0, P3
cmp P0, P2
cmovge S2, P0
cmovge P0, P2
cmovg P2, S2
cmp P1, S0
cmovge S0, P1
cmovge P1, P3
mov S1, P0
cmovge P3, S0
cmp P3, P2
cmovg S0, P2
cmovl P3, P2
cmovl P2, S0

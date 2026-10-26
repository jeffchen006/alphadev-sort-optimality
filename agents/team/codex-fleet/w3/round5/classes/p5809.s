# n=5 model=out iset=I1 prefix14_class=5809
mov S0, P3
cmp P1, S0
cmovl P3, P1
cmovg S0, P1
cmp P2, P0
mov S2, P3
cmovg P1, P2
cmovg P2, P0
cmovg P0, P1
cmp P2, S2
cmovge S2, P2
mov S1, S0
cmovge P2, P3
cmp P0, S1

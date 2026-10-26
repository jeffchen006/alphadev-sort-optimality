# n=5 model=out iset=I1 prefix14_class=10658
mov S1, P0
cmp P1, P0
cmovl P0, P1
cmovl P1, S1
mov S0, P1
cmp P2, P3
cmovge S1, P3
cmovge P3, P2
cmovg P2, S1
cmp S0, P3
cmovge P1, P3
cmovge P3, S0
cmp P2, P0
cmovge S1, P2

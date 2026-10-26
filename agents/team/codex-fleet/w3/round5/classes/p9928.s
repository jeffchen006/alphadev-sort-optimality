# n=5 model=out iset=I1 prefix14_class=9928
mov S0, P0
cmp P2, P3
cmovge S1, P2
cmovge P2, P3
cmovg P3, S1
mov S2, P3
cmp P0, P1
cmovl P0, P1
cmovl P1, S0
cmp S2, P0
cmovl P3, P0
cmovg S2, P0
cmp P2, P1
mov P3, P2

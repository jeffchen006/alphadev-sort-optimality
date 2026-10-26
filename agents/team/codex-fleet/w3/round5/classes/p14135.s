# n=5 model=out iset=I1 prefix14_class=14135
cmp P1, P0
cmovl S0, P1
cmovl P1, P0
mov S2, P1
cmovl P0, S0
cmp P2, P3
mov S1, P3
cmovge P3, P2
cmovg P2, S1
cmp S2, P3
cmovl P1, P3
cmovg S2, P3
mov S1, P2
cmovl P3, S2

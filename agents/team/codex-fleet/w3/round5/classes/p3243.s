# n=5 model=out iset=I1 prefix14_class=3243
mov S0, P0
mov S1, P3
cmp P1, P0
cmovg P0, P1
cmovge P1, S0
cmp P2, P3
cmovge S1, P2
cmovg P2, P3
mov P3, P1
cmp P3, P2
cmovl P3, P2
cmovge P1, P2
cmp S1, P0
cmovg S2, P0

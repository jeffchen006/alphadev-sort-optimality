# n=5 model=out iset=I1 prefix14_class=11423
cmp P1, P0
mov S1, P1
cmovl S1, P0
cmovge P1, P0
mov S0, P2
cmp S0, P3
cmovg P2, P3
cmovge P3, S0
cmp P1, P2
mov S2, P1
cmovl S2, P2
cmovle P2, P1
cmp P3, S1
cmovge P1, S1

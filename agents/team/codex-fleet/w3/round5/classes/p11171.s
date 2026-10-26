# n=5 model=out iset=I1 prefix14_class=11171
mov S0, P3
cmp P3, P2
cmovge P3, P2
cmovge P2, S0
mov S2, P1
cmp P0, P1
cmovg P1, P0
mov S1, P2
cmovl S2, P0
cmp P1, P2
cmovl P2, P1
cmovle P1, S1
cmp S2, P3
cmovl S1, P2

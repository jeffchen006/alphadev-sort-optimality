# n=5 model=out iset=I1 prefix14_class=3532
mov S2, P1
mov S0, P3
cmp P2, P1
cmovge S2, P2
cmovge P2, P1
cmp P3, P0
cmovle P3, P0
mov S1, P2
cmovle P0, S0
cmp P0, P2
cmovg P2, P0
cmovl S1, P0
cmp S2, P3
cmovg P1, P3

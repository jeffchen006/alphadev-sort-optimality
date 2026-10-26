# n=5 model=out iset=I1 prefix14_class=8528
mov S0, P3
cmp S0, P0
mov S2, P1
cmovle P3, P0
cmovle P0, S0
cmp P2, S2
cmovl S2, P2
cmovg P1, P2
cmp P3, P1
cmovg P2, P1
cmovge P1, P3
cmovg P3, P2
cmp P0, S2
cmovge S1, P0

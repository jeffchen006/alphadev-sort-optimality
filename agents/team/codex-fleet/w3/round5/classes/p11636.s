# n=5 model=out iset=I1 prefix14_class=11636
cmp P0, P1
mov S2, P1
cmovge S2, P0
cmovg P0, P1
cmp P2, P3
cmovge S1, P2
cmovge P2, P3
cmovg P3, S1
cmp S2, P3
cmovle P1, S2
cmovl S2, P3
cmovg P1, P3
cmp P2, P0
cmovge S1, P0

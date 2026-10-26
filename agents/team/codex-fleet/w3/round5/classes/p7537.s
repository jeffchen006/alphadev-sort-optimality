# n=5 model=out iset=I1 prefix14_class=7537
cmp P3, P1
cmovge S1, P1
cmovge P1, P3
cmovl S1, P3
cmp P0, P2
cmovg P3, P2
cmovg P2, P0
mov S2, S1
cmovg P0, P3
cmp S1, P0
cmovl S2, P0
cmovle P0, S1
cmp P2, P1
cmovl S1, P2

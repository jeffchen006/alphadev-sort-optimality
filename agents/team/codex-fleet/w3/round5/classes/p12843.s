# n=5 model=out iset=I1 prefix14_class=12843
mov S2, P0
cmp P0, P1
cmovl S2, P1
cmovl P1, P0
mov S1, P2
cmp S1, P3
cmovg P2, P3
cmovl S1, P3
cmp P1, P2
cmovg P0, P1
cmovge P1, P2
cmovg P2, P0
cmp S2, S1
cmovle P0, S2

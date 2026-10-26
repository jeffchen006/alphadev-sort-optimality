# n=5 model=out iset=I1 prefix14_class=8733
mov S1, P2
cmp P2, P1
cmovl S1, P1
cmovg P2, P1
cmp P3, P0
cmovge P1, P3
cmovl P1, P0
cmovle P0, P3
cmp S1, P1
cmovl S2, P1
cmovl P1, S1
cmovl S1, S2
cmp P2, P0
cmovg S1, P2

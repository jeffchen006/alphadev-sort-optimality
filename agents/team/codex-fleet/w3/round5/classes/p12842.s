# n=5 model=out iset=I1 prefix14_class=12842
mov S2, P3
cmp P3, P1
cmovl S2, P1
cmovl P1, P3
mov S1, P2
cmp S1, P0
cmovg S1, P0
cmovl P2, P0
cmp P1, S1
cmovg P3, P1
cmovge P1, S1
cmovg S1, P3
cmp S2, P2
cmovle P3, S2

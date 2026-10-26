# n=5 model=out iset=I1 prefix14_class=13930
mov S2, P0
cmp S2, P2
cmovl S2, P2
cmovl P2, P0
cmp P1, P3
cmovg S1, P3
cmovge P3, P1
cmovg P1, S1
cmp P3, S2
cmovge P0, P3
cmovg P3, S2
cmovle P0, S2
mov S2, P2
cmp P1, S2

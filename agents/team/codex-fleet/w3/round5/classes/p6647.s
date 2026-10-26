# n=5 model=out iset=I1 prefix14_class=6647
cmp P3, P2
cmovge S1, P2
cmovg P2, P3
cmovge P3, S1
cmp P0, P1
cmovg S2, P1
cmovg P1, P0
mov S1, P2
cmovg P0, S2
cmp S1, P1
cmovle P2, P1
cmovl P1, S1
cmovg S1, P1
cmp P3, P0

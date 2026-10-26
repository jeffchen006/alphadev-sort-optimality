# n=5 model=out iset=I1 prefix14_class=12709
cmp P2, P0
cmovg S1, P0
cmovge P0, P2
cmovg P2, S1
mov S1, P1
cmp P1, P3
cmovle P1, P3
cmovl P3, S1
cmp P3, P2
cmovge S2, P2
cmovge P2, P3
cmovg P3, S2
mov S1, P0
cmp S1, P1

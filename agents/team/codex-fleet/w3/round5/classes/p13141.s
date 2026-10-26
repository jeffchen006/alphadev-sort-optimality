# n=5 model=out iset=I1 prefix14_class=13141
cmp P0, P3
mov S1, P0
cmovl P0, P3
cmovg S1, P3
cmp P2, P1
cmovle P3, P2
cmovg P3, P1
cmovl P2, P1
cmp S1, P3
cmovge S2, S1
cmovg S1, P3
cmovge P3, S2
mov S1, P0
cmp S1, P2

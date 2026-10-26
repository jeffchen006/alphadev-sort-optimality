# n=5 model=out iset=I1 prefix14_class=1997
mov S1, P3
mov S2, P2
cmp P3, P1
cmovl S1, P1
cmovg P3, P1
cmp P0, S2
cmovle S2, P0
cmovge P2, P0
cmp S1, P2
mov P0, S1
cmovl P0, P2
cmovle P2, S1
cmp S2, P3
cmovge S1, P3

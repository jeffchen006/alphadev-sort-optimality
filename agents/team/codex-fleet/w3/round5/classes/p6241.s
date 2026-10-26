# n=5 model=out iset=I1 prefix14_class=6241
mov S2, P2
cmp S2, P0
cmovl P2, P0
cmovg S2, P0
cmp P1, P3
cmovg P0, P3
mov S1, P2
cmovge P3, P1
cmovg P1, P0
cmp P3, P2
cmovge S1, P3
cmovle P2, P3
cmp P1, S2
cmovge P3, S2

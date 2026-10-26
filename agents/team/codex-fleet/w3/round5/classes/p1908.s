# n=5 model=out iset=I1 prefix14_class=1908
cmp P3, P2
mov S2, P2
cmovle P2, P3
cmovle P3, S2
cmp P0, P1
mov S2, P1
cmovl P1, P0
cmovge S2, P0
cmp S2, P3
cmovge P0, P3
cmovge P3, S2
cmovg S2, P0
mov S1, P2
cmp P2, P1

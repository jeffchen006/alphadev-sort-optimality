# n=5 model=out iset=I1 prefix14_class=11933
cmp P3, P2
mov S2, P2
mov S1, P0
cmovl P2, P3
cmovge S2, P3
cmp P0, P1
cmovl P0, P1
cmovl P1, S1
cmp S2, P0
cmovge P3, S2
cmovge S2, P0
cmovge P0, P3
cmp P2, P1
cmovle P3, P2

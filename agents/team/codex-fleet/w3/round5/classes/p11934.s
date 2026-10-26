# n=5 model=out iset=I1 prefix14_class=11934
cmp P3, P2
mov S2, P2
mov S1, P0
cmovl P2, P3
cmovge S2, P3
cmp S1, P1
cmovl S1, P1
cmovle P1, P0
cmp S2, S1
cmovge P0, S2
cmovg S2, S1
cmovge S1, P0
cmp P2, P1
cmovle P0, P2

# n=5 model=out iset=I1 prefix14_class=12800
mov S2, P1
mov S1, P3
cmp P0, P3
cmovle P3, P0
cmovg S1, P0
cmp S2, P2
cmovge S2, P2
cmovge P2, P1
cmp S2, P3
cmovge P0, S2
cmovge S2, P3
cmovge P3, P0
cmp S1, P2
cmovl P0, S1

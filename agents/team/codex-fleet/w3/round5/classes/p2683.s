# n=5 model=out iset=I1 prefix14_class=2683
mov S2, P3
cmp S2, P2
cmovge S2, P2
mov S1, P0
cmovge P2, P3
cmp S1, P1
cmovg S1, P1
cmovle P0, P1
cmp P2, P0
mov P3, P2
cmovl P2, P0
mov P2, S1
cmovge P3, P0
cmp P2, S2

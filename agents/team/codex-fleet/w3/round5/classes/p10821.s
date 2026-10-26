# n=5 model=out iset=I1 prefix14_class=10821
mov S1, P3
cmp P2, S1
cmovle P3, P2
cmovg S1, P2
cmp P0, P1
mov P2, P0
cmovge P0, P1
cmovle P2, P1
cmp S1, P2
mov P1, S1
cmovge S1, P2
cmovl S2, P0
cmovle P1, P2
cmp P3, P0

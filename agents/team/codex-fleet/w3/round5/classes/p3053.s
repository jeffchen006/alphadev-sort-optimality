# n=5 model=out iset=I1 prefix14_class=3053
cmp P0, P2
cmovge S1, P0
cmovg P0, P2
cmovl S1, P2
mov P2, P1
cmp P3, P1
cmovle P2, P3
cmovle P3, P1
mov P1, P0
cmp P2, P1
cmovg P0, P2
cmovge P2, P1
cmp S1, P3
cmovge S0, S1

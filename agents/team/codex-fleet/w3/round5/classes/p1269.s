# n=5 model=out iset=I1 prefix14_class=1269
cmp P2, P0
mov S2, P2
cmovge P2, P0
mov S1, P3
cmovl S2, P0
cmp P3, P1
cmovl S1, P1
cmovle P1, P3
mov P0, S2
cmp P0, S1
cmovl S2, S1
cmovge P0, S1
mov S2, P2
cmp P2, P1

# n=5 model=out iset=I1 prefix14_class=3051
cmp P1, P2
mov S1, P1
cmovge P1, P2
cmovl S1, P2
mov P2, P0
cmp P3, P0
cmovle P2, P3
cmovle P3, P0
mov P0, P1
cmp P2, P0
cmovg P1, P2
cmovge P2, P0
cmp S1, P3
cmovl S2, P3

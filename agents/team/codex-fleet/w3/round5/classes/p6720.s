# n=5 model=out iset=I1 prefix14_class=6720
mov S2, P1
cmp S2, P0
cmovl S2, P0
cmovg P1, P0
cmp P3, P2
mov P0, P2
cmovg P0, P3
cmovge P3, P2
cmovge P2, P0
cmp P2, S2
cmovg P2, S2
cmovle P0, S2
cmp P1, P3
cmovle P0, P3

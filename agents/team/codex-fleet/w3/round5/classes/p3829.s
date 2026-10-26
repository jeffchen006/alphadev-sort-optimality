# n=5 model=out iset=I1 prefix14_class=3829
mov S2, P1
cmp P1, P2
cmovge S2, P2
cmovge P2, P1
mov P1, P3
cmp P0, P3
cmovle P3, P0
cmovg P1, P0
cmp P3, S2
cmovge S1, P3
cmovl S1, S2
cmovl S2, P3
cmp P2, P1
cmovg P3, P2

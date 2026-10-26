# n=5 model=out iset=I1 prefix14_class=4752
cmp P2, P0
cmovge S2, P2
cmovge P2, P0
cmovl S2, P0
cmp P3, P1
cmovg P0, P3
cmovle P0, P1
mov S1, P2
cmovge P3, P1
cmp P3, P2
cmovge S1, P3
cmovge P3, P2
cmp P0, S2
cmovge P3, P0

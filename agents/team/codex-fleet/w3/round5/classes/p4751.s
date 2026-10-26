# n=5 model=out iset=I1 prefix14_class=4751
cmp P2, P3
mov S2, P2
cmovge P2, P3
cmovl S2, P3
cmp P0, P1
cmovg P3, P0
cmovle P3, P1
mov S1, P2
cmovge P0, P1
cmp P0, P2
cmovge S1, P0
cmovge P0, P2
cmp P3, S2
cmovge P0, P3

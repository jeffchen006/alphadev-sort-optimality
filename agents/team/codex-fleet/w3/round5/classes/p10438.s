# n=5 model=out iset=I1 prefix14_class=10438
cmp P3, P0
cmovge S2, P0
cmovge P0, P3
cmovl S2, P3
cmp P2, P1
mov P3, P1
cmovg P1, P2
cmovle P3, P2
cmp P0, P1
cmovle P2, P0
cmovge P2, P1
cmovle P0, P1
cmp P3, S2
cmovle P1, S2

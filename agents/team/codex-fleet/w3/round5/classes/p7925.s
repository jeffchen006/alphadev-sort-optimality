# n=5 model=out iset=I1 prefix14_class=7925
cmp P2, P3
mov S2, P2
cmovle P2, P3
cmovle P3, S2
mov S2, P0
cmp P0, P1
cmovge P0, P1
cmovg P1, S2
cmp P3, P0
mov S2, P0
cmovl S2, P3
cmovg P0, P3
cmp P2, P1
cmovle P3, P2

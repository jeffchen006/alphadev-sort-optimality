# n=5 model=out iset=I1 prefix14_class=5472
mov S0, P1
cmp P1, P3
cmovle P1, P3
cmovle P3, S0
cmp P0, P2
cmovge S2, P0
cmovl S2, P2
cmovg P0, P2
mov P2, P0
cmp P2, P3
cmovle P0, P3
cmovge P2, P3
cmp P1, S2
cmovle P3, P1

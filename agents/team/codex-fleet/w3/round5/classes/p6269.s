# n=5 model=out iset=I1 prefix14_class=6269
mov S1, P3
mov S2, P0
cmp P1, S1
cmovl S1, P1
cmovle P1, P3
cmp P2, S2
cmovge P0, P2
mov P3, P1
cmovl S2, P2
cmp P0, P3
cmovle P3, P0
cmovle P0, P1
cmovle P1, P3
mov P0, S2

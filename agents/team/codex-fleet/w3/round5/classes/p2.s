# n=5 model=out iset=I1 prefix14_class=2
mov S2, P0
mov S1, P1
cmp P3, P1
cmovle P1, P3
cmovle P3, S1
cmp P2, P0
cmovg S2, P2
cmovle P0, P2
cmp P1, P0
mov P2, P3
cmovl S1, P1
cmovge S1, P0
cmovg P0, P1
cmp P2, S2

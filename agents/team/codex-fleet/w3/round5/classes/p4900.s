# n=5 model=out iset=I1 prefix14_class=4900
mov S1, P3
cmp P3, P1
cmovl S1, P1
mov S2, P2
cmovl P1, P3
cmp P0, S2
cmovle P2, P0
cmovle P0, S2
cmp P2, P1
mov P3, P2
cmovge P2, P1
cmovle P3, P1
cmp S1, P0
cmovg P2, P0

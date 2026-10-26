# n=5 model=out iset=I1 prefix14_class=6450
cmp P2, P0
cmovl S1, P2
cmovle P2, P0
cmovl P0, S1
mov S2, P1
cmp S2, P3
cmovg S2, P3
cmovl P1, P3
mov P3, P2
cmp P3, P1
cmovge P2, P1
cmovg P1, P3
cmp S2, P0
cmovl P3, S2

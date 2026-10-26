# n=5 model=out iset=I1 prefix14_class=13400
mov S1, P1
cmp P0, P2
cmovge S2, P0
cmovg P0, P2
cmovge P2, S2
cmp P3, P1
cmovl P1, P3
cmovg S1, P3
mov P3, P1
cmp P0, P1
cmovle P3, P0
cmovl P0, P1
cmp P2, S1
cmovl S2, S1

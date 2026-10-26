# n=5 model=out iset=I1 prefix14_class=1332
cmp P3, P1
cmovge S1, P3
cmovl S1, P1
cmovle P1, P3
cmp P2, P0
mov S2, P2
cmovg S2, P0
mov P3, S1
cmovg P0, P2
cmp P0, S1
cmovl S1, P0
cmovge P3, P0
cmp P1, S2
cmovge P3, S2

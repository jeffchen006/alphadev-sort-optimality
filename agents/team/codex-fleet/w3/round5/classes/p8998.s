# n=5 model=out iset=I1 prefix14_class=8998
cmp P2, P1
cmovge S1, P1
cmovge P1, P2
cmovg P2, S1
cmp P0, P3
mov S2, P0
cmovg S2, P3
cmovle P0, P3
cmp P1, P0
cmovl P3, P1
cmovge P3, P0
cmovg P0, P1
cmovg P1, P3
cmp P2, S2

# n=5 model=out iset=I1 prefix14_class=9644
mov S1, P1
cmp P1, P3
cmovge P1, P3
cmovg P3, S1
mov S1, P2
cmp P2, P0
cmovg S1, P0
cmovle P2, P0
cmovge P0, P2
cmp P2, P3
cmovle P0, P3
cmovl P3, P2
cmp P1, S1
cmovge S2, S1

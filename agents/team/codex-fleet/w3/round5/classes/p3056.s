# n=5 model=out iset=I1 prefix14_class=3056
mov S1, P3
cmp P0, S1
cmovge S1, P0
cmovge P0, P3
mov P3, P1
cmp P2, P3
cmovl P1, P2
cmovle P2, P3
cmp P1, P0
cmovg P3, P1
cmovg P1, P0
cmovg P0, P3
mov P3, P0
cmp P2, S1

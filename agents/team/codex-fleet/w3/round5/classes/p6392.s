# n=5 model=out iset=I1 prefix14_class=6392
cmp P2, P3
cmovge S2, P2
cmovge P2, P3
cmovg P3, S2
mov S2, P1
cmp P0, P1
cmovle P1, P0
cmovl P0, S2
cmp P0, P3
mov S1, P0
cmovge S1, P3
cmovge P3, P0
mov P3, S1
cmp P1, P2

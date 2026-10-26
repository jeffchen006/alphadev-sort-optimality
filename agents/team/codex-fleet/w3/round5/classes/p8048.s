# n=5 model=out iset=I1 prefix14_class=8048
cmp P0, P3
cmovge S1, P0
mov S2, P2
cmovg P0, P3
cmovg P3, S1
cmp P1, S2
cmovge S2, P1
cmovg P1, P2
cmovl P2, P1
cmp P2, P0
cmovle P1, P0
cmovg P2, P0
cmovge P0, P1
mov P2, P3

# n=5 model=out iset=I1 prefix14_class=7380
cmp P0, P2
mov S1, P0
mov S2, P1
cmovl P0, P2
cmovle P2, S1
cmovle S1, P0
cmp P1, P3
cmovge S2, P3
cmovge P3, P1
cmp P2, S2
cmovg P1, S2
cmovge S2, P2
cmovg P2, P1
mov P2, S2

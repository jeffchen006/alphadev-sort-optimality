# n=5 model=out iset=I1 prefix14_class=6361
cmp P1, P0
mov S1, P1
cmovg P1, P0
cmovge P0, S1
cmp P2, P3
cmovge S2, P3
cmovge P3, P2
cmovl S2, P2
cmp P3, P0
cmovle S1, P3
cmovge S1, P0
cmovge P0, P3
cmp P1, S2
cmovle P2, S2

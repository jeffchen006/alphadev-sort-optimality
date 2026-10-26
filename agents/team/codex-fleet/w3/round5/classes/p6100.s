# n=5 model=out iset=I1 prefix14_class=6100
mov S2, P0
cmp P0, P1
cmovle S2, P1
cmovle P1, P0
cmp P3, P2
mov S1, P2
cmovge S1, P3
cmovg P3, P2
mov P0, S1
cmp P0, S2
cmovge S1, S2
cmovge S2, P0
cmp P3, P1
mov S2, P1

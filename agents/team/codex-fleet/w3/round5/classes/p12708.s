# n=5 model=out iset=I1 prefix14_class=12708
cmp P2, P0
cmovge S1, P0
cmovg P0, P2
cmovg P2, S1
cmp P1, P3
cmovle S1, P1
cmovle P1, P3
cmovle P3, S1
cmp P3, P2
cmovge S2, P2
cmovg P2, P3
mov S0, P0
cmovg P3, S2
cmp P0, P1

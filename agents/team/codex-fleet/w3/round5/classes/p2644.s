# n=5 model=out iset=I1 prefix14_class=2644
cmp P2, P3
cmovl S2, P3
cmovge S2, P2
mov S1, P0
cmovge P2, P3
mov P3, S2
cmp P1, P0
cmovl S1, P1
cmovg P0, P1
cmp P0, S2
cmovle S2, P0
cmovle P0, P3
cmp P2, S1
cmovle P0, P2

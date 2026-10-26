# n=5 model=out iset=I1 prefix14_class=763
cmp P0, P1
cmovge S1, P1
cmovle S1, P0
cmovle P0, P1
cmp P2, P3
mov S2, P2
cmovg P2, P3
cmovl S2, P3
cmp S2, P0
cmovle P1, P0
cmovl P0, S2
cmovge P1, S2
mov P1, P2
cmp P1, S1

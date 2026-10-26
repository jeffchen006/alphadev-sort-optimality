# n=5 model=out iset=I1 prefix14_class=5591
cmp P2, P0
cmovge S2, P2
mov S1, P1
cmovge P2, P0
cmovge P0, S2
cmp S1, P3
cmovle S1, P3
cmovl P3, P1
cmp P2, P3
cmovle P1, P3
cmovg P1, P2
cmovl P3, P2
mov S0, P0
cmovl P2, P1

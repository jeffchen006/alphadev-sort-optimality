# n=5 model=out iset=I1 prefix14_class=5015
cmp P2, P3
cmovl S2, P2
cmovle P2, P3
cmovl P3, S2
cmp P1, P0
mov S0, P2
cmovge S1, P1
cmovle S1, P0
cmovge P1, P0
mov P0, P1
cmp P0, P3
cmovge P0, P3
cmovg P3, P1
cmp S0, S1

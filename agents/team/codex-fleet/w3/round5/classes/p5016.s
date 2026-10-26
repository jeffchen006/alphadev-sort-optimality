# n=5 model=out iset=I1 prefix14_class=5016
cmp P1, P3
cmovle S2, P1
cmovle P1, P3
cmovl P3, S2
mov S0, P1
cmp P0, P2
cmovge S1, P0
cmovle S1, P2
cmovg P0, P2
mov P2, P3
cmp P3, P0
cmovg P2, P0
cmovge P0, P3
cmp S0, S1

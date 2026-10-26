# n=5 model=out iset=I1 prefix14_class=4460
cmp P0, P3
cmovge S0, P3
cmovg P3, P0
cmovge P0, S0
cmp P2, P1
cmovle S1, P1
cmovge S1, P2
cmovl P1, P2
cmp S1, P3
cmovle S0, S1
cmovl S1, P3
cmovle P3, S0
mov P2, P0
cmp P2, P1

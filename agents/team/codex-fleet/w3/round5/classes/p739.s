# n=5 model=out iset=I1 prefix14_class=739
cmp P3, P0
cmovle S2, P3
cmovle P3, P0
cmovge S2, P0
cmp P1, P2
mov P0, P1
cmovge P0, P2
cmovl P1, P2
cmp P1, P3
mov S0, P1
cmovl P1, P3
cmovl P3, S0
mov S0, P0
cmp S0, S2

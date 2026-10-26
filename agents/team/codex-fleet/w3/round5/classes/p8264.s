# n=5 model=out iset=I1 prefix14_class=8264
cmp P2, P0
cmovle S1, P0
cmovle P0, P2
cmovle P2, S1
cmp P3, P1
cmovl S0, P1
cmovl P1, P3
cmovge S0, P3
cmp P1, P0
cmovge P3, P1
cmovg P1, P0
mov P1, P2
cmovge P0, P3
cmp S0, P2

# n=5 model=out iset=I1 prefix14_class=4069
cmp P2, P0
cmovl S2, P0
cmovge S2, P2
cmovle P0, P2
cmp P3, P1
cmovge S0, P3
cmovle S0, P1
cmovge P3, P1
mov P1, P3
cmp P1, P0
cmovg P1, P0
cmovle P3, P0
cmp S0, S2
cmovl P2, S0

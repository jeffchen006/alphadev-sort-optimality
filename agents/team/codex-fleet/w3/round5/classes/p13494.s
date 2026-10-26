# n=5 model=out iset=I1 prefix14_class=13494
cmp P3, P1
cmovl S0, P1
cmovge S0, P3
cmovl P1, P3
cmp P2, P0
cmovge P3, P2
cmovl P3, P0
cmovl P0, P2
cmp P0, P1
cmovle S2, P1
cmovle P1, P0
mov P1, P3
cmovl P0, S2
cmp S0, P1

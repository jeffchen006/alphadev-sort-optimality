# n=5 model=out iset=I1 prefix14_class=14007
cmp P3, P2
cmovle S1, P2
cmovl P2, P3
cmovge S1, P3
cmp P0, P1
cmovle S0, P0
cmovle P0, P1
mov P3, P2
cmovl P1, S0
cmp S1, P0
cmovl S0, S1
cmovl S1, P0
cmovl P0, S0
cmp P1, P2

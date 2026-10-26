# n=5 model=out iset=I1 prefix14_class=12440
mov S0, P0
cmp S0, P2
cmovl S0, P2
cmovl P2, P0
cmp P3, P1
cmovle S1, P3
cmovl P3, P1
cmovge S1, P1
cmp P2, S1
cmovle P1, S1
cmovle S1, P2
cmovl P2, P1
cmp S0, P3
cmovle S1, S0

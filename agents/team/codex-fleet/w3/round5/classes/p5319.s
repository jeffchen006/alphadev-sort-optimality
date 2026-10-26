# n=5 model=out iset=I1 prefix14_class=5319
mov S1, P0
cmp P0, P3
cmovle S1, P3
cmovl P3, P0
mov S0, P1
cmp S0, P2
cmovge S0, P2
cmovle P1, P2
mov P2, S0
cmp P3, S0
cmovl S0, P3
cmovg P2, P3
cmp P1, S1
cmovle P3, P1

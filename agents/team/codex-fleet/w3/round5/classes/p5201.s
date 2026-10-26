# n=5 model=out iset=I1 prefix14_class=5201
mov S1, P0
cmp S1, P3
cmovle P0, P3
cmovl P3, S1
cmp P2, P1
cmovle S0, P1
cmovl P1, P2
cmovle P2, S0
cmp P3, P1
mov S1, P3
cmovge S1, P1
cmovg P1, P3
mov S1, P2
cmp P0, S1

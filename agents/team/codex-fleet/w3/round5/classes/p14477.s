# n=5 model=out iset=I1 prefix14_class=14477
cmp P0, P1
cmovl S1, P1
cmovl P1, P0
mov S0, P3
cmovge S1, P0
cmp S0, P2
cmovle S0, P2
cmovg P3, P2
cmp P3, P1
cmovle P0, P1
cmovl P1, P3
mov P1, S1
cmovle P3, P0
cmp S0, S1

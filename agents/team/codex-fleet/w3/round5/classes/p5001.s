# n=5 model=out iset=I1 prefix14_class=5001
cmp P2, P1
cmovle S0, P1
mov S1, P3
cmovl P1, P2
cmovl P2, S0
mov S0, P2
cmp P0, S1
cmovle S1, P0
cmovg P3, P0
cmp S1, P1
cmovle P0, P1
cmovl P1, S1
cmovl S1, P0
cmp S0, P3

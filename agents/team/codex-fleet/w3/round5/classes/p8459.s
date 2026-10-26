# n=5 model=out iset=I1 prefix14_class=8459
cmp P1, P0
cmovge S0, P1
mov S1, P2
cmovg P1, P0
cmovl S0, P0
cmp S1, P3
cmovle S1, P3
cmovle P3, P2
cmp S0, S1
cmovl P0, S1
cmovl S1, S0
cmovl S0, P0
mov P2, P1
cmp P3, P1

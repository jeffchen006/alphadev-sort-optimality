# n=5 model=out iset=I1 prefix14_class=10381
cmp P3, P0
cmovl S1, P3
cmovle P3, P0
mov S0, P2
cmovl P0, S1
cmp S0, P1
cmovge S0, P1
cmovle P2, P1
cmp P3, P2
cmovg P1, P3
mov S1, P0
cmovge P3, P2
cmovg P2, P1
cmp P0, S0

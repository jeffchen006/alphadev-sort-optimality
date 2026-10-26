# n=5 model=out iset=I1 prefix14_class=5499
cmp P2, P3
cmovl S0, P2
cmovle P2, P3
mov S1, P1
cmovl P3, S0
cmp S1, P0
cmovl S1, P0
cmovge P1, P0
mov S0, P3
cmp S0, P1
cmovl P3, P1
cmovle P1, S0
cmp P2, S1
cmovle P0, P2

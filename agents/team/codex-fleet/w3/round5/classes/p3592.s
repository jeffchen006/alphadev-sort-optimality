# n=5 model=out iset=I1 prefix14_class=3592
mov S1, P3
cmp S1, P1
mov S0, P2
cmovle P3, P1
cmovle P1, S1
cmp P0, P2
cmovle P2, P0
cmovle P0, S0
cmp P2, P1
cmovl S1, P1
cmovl P1, P2
cmovl P2, S1
cmp P0, P3
cmovge S0, P0

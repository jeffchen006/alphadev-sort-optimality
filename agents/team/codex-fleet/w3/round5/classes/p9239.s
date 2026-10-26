# n=5 model=out iset=I1 prefix14_class=9239
mov S0, P0
cmp P1, P2
mov S1, P2
cmovle P2, P1
cmovge S1, P1
cmp P3, S0
cmovl S0, P3
cmovge P0, P3
cmp S0, P2
cmovl P1, P2
cmovle P2, S0
cmovl S0, P1
mov P2, S1
cmp P0, P2

# n=5 model=out iset=I1 prefix14_class=9068
cmp P0, P2
cmovge S0, P2
cmovge P2, P0
mov S1, P3
cmovl S0, P0
cmp S1, P1
cmovl S1, P1
cmovle P1, P3
cmp S1, P2
cmovle P3, S1
cmovle S1, P2
cmovl P2, P3
mov P0, S0
cmp P1, P0

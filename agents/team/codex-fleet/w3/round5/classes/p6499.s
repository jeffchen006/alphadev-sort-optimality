# n=5 model=out iset=I1 prefix14_class=6499
mov S1, P1
cmp P2, S1
cmovl S1, P2
cmovge P1, P2
cmovle P2, P1
cmp P0, P3
cmovle S0, P3
cmovge S0, P0
cmovle P3, P0
cmp S0, P1
cmovl P2, S0
cmovl S0, P1
cmp S1, P3
cmovle P0, P3

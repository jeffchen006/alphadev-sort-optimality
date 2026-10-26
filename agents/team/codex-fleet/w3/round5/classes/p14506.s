# n=5 model=out iset=I1 prefix14_class=14506
cmp P1, P0
mov S0, P0
cmovge P0, P1
cmovge P1, S0
cmovle S0, P1
cmp P2, P3
cmovl S1, P3
cmovle P3, P2
cmovl P2, S1
cmp S0, P3
cmovl S0, P3
cmovl P3, P1
mov P3, P2
cmp P0, P2

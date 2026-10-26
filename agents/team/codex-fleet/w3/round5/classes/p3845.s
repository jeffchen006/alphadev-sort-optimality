# n=5 model=out iset=I1 prefix14_class=3845
mov S0, P3
cmp S0, P0
cmovge P3, P0
cmovge P0, S0
cmp P1, P2
mov S0, P1
cmovle S0, P2
cmovl P2, P1
cmp P3, P2
cmovl S1, P3
cmovl P3, P2
cmovl P2, S1
cmp P0, S0
cmovle P2, S0

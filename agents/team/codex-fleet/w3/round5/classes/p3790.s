# n=5 model=out iset=I1 prefix14_class=3790
cmp P1, P3
mov S0, P1
cmovge P1, P3
mov S1, P1
cmovge P3, S0
cmp P0, P2
cmovle S0, P0
cmovge S0, P2
cmovle P0, P2
cmp S1, S0
cmovl P1, S0
cmovl S0, S1
mov S0, P0
cmp P3, S0

# n=5 model=out iset=I1 prefix14_class=11391
cmp P0, P1
cmovle S1, P1
cmovle P1, P0
cmovl P0, S1
mov S0, P3
cmp S0, P2
cmovle S0, P2
cmovge P3, P2
cmp S0, P0
mov S2, P0
cmovl P0, S0
cmovl S0, S2
cmp P1, P3
cmovge S1, P3

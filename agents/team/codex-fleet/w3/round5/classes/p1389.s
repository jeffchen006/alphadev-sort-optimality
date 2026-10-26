# n=5 model=out iset=I1 prefix14_class=1389
mov S0, P2
cmp P0, P1
cmovge S1, P1
cmovle S1, P0
cmovge P1, P0
cmovle P0, P1
cmp S0, P3
cmovge S0, P3
cmovge P3, P2
cmp P3, P0
cmovl P0, P3
cmovle P3, P1
cmovl P1, P0
mov P3, S0

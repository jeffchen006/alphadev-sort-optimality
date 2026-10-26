# n=5 model=out iset=I1 prefix14_class=6540
cmp P2, P0
cmovle S0, P0
mov S1, P3
cmovge S0, P2
cmovl P0, P2
cmp P3, P1
cmovle S1, P1
cmovle P1, P3
cmovle P3, S1
cmp S1, S0
cmovl S1, S0
cmovge P3, S0
cmp P1, P0
cmovl S1, P0

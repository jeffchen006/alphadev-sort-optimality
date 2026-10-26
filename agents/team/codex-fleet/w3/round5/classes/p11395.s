# n=5 model=out iset=I1 prefix14_class=11395
mov S0, P3
cmp P1, P0
cmovle S1, P0
cmovle P0, P1
cmovl P1, S1
cmp S0, P2
cmovl S0, P2
cmovge P3, P2
mov S2, S0
cmp P1, S0
cmovl S0, P1
cmovl P1, S2
cmp P0, P3
cmovge S1, P3

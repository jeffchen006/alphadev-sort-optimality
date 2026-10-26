# n=5 model=out iset=I1 prefix14_class=3102
mov S0, P1
cmp S0, P0
cmovle P1, P0
mov S1, P2
cmovle P0, S0
cmovge S0, P0
cmp P3, P2
cmovl P2, P3
cmovle P3, S1
cmp P0, P2
cmovl P0, P2
cmovge S0, P2
cmp P3, P1
cmovge P2, P3

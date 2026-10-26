# n=5 model=out iset=I1 prefix14_class=138
mov S0, P2
mov S1, P3
cmp S1, P1
cmovge S1, P1
cmovle P3, P1
cmp P0, S0
cmovle P2, P0
cmovg S0, P0
cmp P2, S1
cmovl P1, P2
cmovl P2, S1
cmovge P1, S1
mov P1, S0
cmp P3, S0

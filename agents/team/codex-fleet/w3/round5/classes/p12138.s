# n=5 model=out iset=I1 prefix14_class=12138
cmp P1, P2
cmovle S1, P2
mov S0, P3
cmovle P2, P1
cmovge S1, P1
cmp P0, S0
cmovge P3, P0
mov P1, S1
cmovge P0, S0
cmp P2, P0
cmovl S0, P0
cmovle P0, P2
cmovl P2, S0
cmp S1, P3

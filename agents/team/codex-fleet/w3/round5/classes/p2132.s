# n=5 model=out iset=I1 prefix14_class=2132
mov S0, P3
cmp P3, P0
cmovle S0, P0
mov S1, P1
cmovle P0, P3
cmp S1, P2
mov P3, S0
cmovl P1, P2
cmovge S1, P2
cmp S0, P1
cmovl P3, P1
cmovle P1, S0
cmp S1, P0
cmovle P2, S1

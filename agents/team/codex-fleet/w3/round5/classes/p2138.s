# n=5 model=out iset=I1 prefix14_class=2138
mov S0, P3
cmp P0, P3
cmovle S0, P0
cmovle P0, P3
cmp P1, P2
mov P3, P1
cmovge P3, P2
mov S1, P0
cmovl P1, P2
cmp S1, P1
cmovl P0, P1
cmovl P1, S1
mov P0, S0
cmp S0, P3

# n=5 model=out iset=I1 prefix14_class=8974
mov S0, P3
cmp P3, P0
cmovle S0, P0
cmovl P0, P3
cmp P1, P2
cmovle P3, P1
mov S1, S0
cmovl P1, P2
cmovle P2, P3
cmp P1, S0
cmovge S0, P1
cmovle S1, P1
mov P1, P2
cmp P1, P0

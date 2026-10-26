# n=5 model=out iset=I1 prefix14_class=8907
mov S0, P3
mov S1, P0
cmp P0, P2
cmovge S1, P2
cmovl P0, P2
cmp P1, P3
cmovl P3, P1
cmovle P1, S0
mov S2, P0
cmp P0, P1
cmovle S2, P1
cmovle P1, P0
cmp S1, P3
cmovge S2, P3

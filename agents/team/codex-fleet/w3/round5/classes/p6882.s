# n=5 model=out iset=I1 prefix14_class=6882
mov S0, P1
mov S1, P3
cmp P1, P0
cmovle P1, P0
cmovge S0, P0
cmp P3, P2
cmovle S1, P2
mov P0, S1
cmovge P3, P2
cmp P1, P0
cmovge S1, P1
cmovle P0, P1
cmp S0, P3
cmovl P2, P3

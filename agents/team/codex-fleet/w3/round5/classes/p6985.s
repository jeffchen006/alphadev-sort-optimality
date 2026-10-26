# n=5 model=out iset=I1 prefix14_class=6985
cmp P2, P0
mov S0, P2
mov S1, P3
cmovge S0, P0
cmovle P2, P0
mov P0, P2
cmp P1, P3
cmovge P3, P1
cmovle S1, P1
cmp P0, P3
cmovge P2, P3
cmovl P0, P3
cmp S0, S1
cmovl P3, S1

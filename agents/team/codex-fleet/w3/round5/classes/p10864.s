# n=5 model=out iset=I1 prefix14_class=10864
mov S1, P0
mov S0, P1
cmp P3, S0
cmovl P1, P3
cmovle P3, S0
cmp P2, P0
cmovge S1, P2
mov S2, S1
cmovle P0, P2
cmp S1, P3
cmovge S2, P3
cmovge P3, S1
cmp P1, P0
cmovle S1, P0

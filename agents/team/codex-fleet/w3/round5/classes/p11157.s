# n=5 model=out iset=I1 prefix14_class=11157
cmp P2, P3
cmovle S1, P2
mov S0, P0
cmovle P2, P3
cmovl P3, S1
cmp S0, P1
cmovge S0, P1
cmovge P1, P0
cmovle P0, P1
cmp P1, P2
cmovge P0, P2
cmovl P1, P2
cmp P3, S0
mov P1, S0

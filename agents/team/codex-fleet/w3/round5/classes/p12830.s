# n=5 model=out iset=I1 prefix14_class=12830
cmp P3, P0
cmovle S2, P3
cmovl P3, P0
mov S1, P1
cmovle P0, S2
cmp S1, P2
cmovge P1, P2
cmovge P2, S1
mov S0, P1
cmp P0, S0
cmovge S0, P0
cmovle P1, P0
cmp P3, P2
mov P1, P3

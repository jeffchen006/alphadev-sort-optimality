# n=5 model=out iset=I1 prefix14_class=10921
cmp P0, P2
cmovge S0, P2
cmovge P2, P0
cmovle S0, P0
cmp P1, P3
cmovl P0, P1
cmovle P1, P3
cmovl P3, P0
mov S2, P1
cmp P1, P2
cmovl P1, P2
cmovle P2, S2
cmp S0, P3
cmovle S2, P3

# n=5 model=out iset=I1 prefix14_class=8602
mov S0, P3
cmp P1, P2
cmovle S2, P2
cmovl P2, P1
cmovl P1, S2
cmp P3, P0
cmovge S0, P0
cmovge P0, P3
cmp P0, P1
cmovle S2, P0
cmovle P0, P1
cmovle P1, S2
cmp S0, P2
mov P0, S0

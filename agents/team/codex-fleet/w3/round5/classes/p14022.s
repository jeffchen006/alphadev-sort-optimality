# n=5 model=out iset=I1 prefix14_class=14022
cmp P3, P2
cmovle S2, P3
cmovl P3, P2
mov S1, P3
cmovge S2, P2
cmp P1, P0
cmovle P2, P1
cmovl P1, P0
cmovl P0, P2
cmp P3, P1
cmovge P3, P1
mov S0, P0
cmovle S1, P1
cmp S2, S0

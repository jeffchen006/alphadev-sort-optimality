# n=5 model=out iset=I1 prefix14_class=12876
cmp P1, P2
cmovle S1, P2
cmovl P2, P1
cmovl P1, S1
mov S0, P3
cmp P0, S0
cmovle S0, P0
cmovle P0, P3
cmovle P3, S0
cmp S0, P2
cmovge P3, P2
cmovle S0, P2
cmp P1, P0
cmovge P2, P1

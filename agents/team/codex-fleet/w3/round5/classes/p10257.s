# n=5 model=out iset=I1 prefix14_class=10257
cmp P0, P3
cmovle S1, P0
mov S0, P1
cmovge S1, P3
cmovl P0, P3
cmp P1, P2
cmovge P1, P2
cmovle S0, P2
cmp P0, S0
cmovle P2, P0
cmovle P0, S0
cmovle S0, P2
cmp P1, S1
cmovle P3, S1

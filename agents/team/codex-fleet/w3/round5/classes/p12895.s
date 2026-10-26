# n=5 model=out iset=I1 prefix14_class=12895
cmp P3, P0
mov S0, P3
cmovle S0, P0
cmovge P3, P0
cmp P2, P1
cmovle S2, P1
cmovle P1, P2
cmovle P2, S2
cmp P3, P1
mov S1, P3
cmovl P3, P1
cmovle P1, S1
cmp S0, P2
cmovl S1, S0

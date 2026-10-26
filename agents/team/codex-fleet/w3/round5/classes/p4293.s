# n=5 model=out iset=I1 prefix14_class=4293
mov S0, P1
cmp S0, P0
cmovle S0, P0
cmovge P1, P0
cmp P2, P3
cmovle S1, P2
cmovle P2, P3
cmovge S1, P3
mov P3, P1
cmp P3, S1
cmovle P3, S1
cmovl S1, P1
cmp S0, P2
cmovle P1, P2

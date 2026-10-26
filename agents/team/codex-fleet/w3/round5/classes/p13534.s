# n=5 model=out iset=I1 prefix14_class=13534
cmp P1, P3
cmovle S1, P1
cmovle P1, P3
cmovge S1, P3
cmp P0, P2
mov P3, P2
cmovle P3, P0
cmovle P0, P2
cmp S1, P3
cmovle S0, S1
cmovl S1, P3
cmovle P3, S0
mov P3, P1
cmp P1, P0

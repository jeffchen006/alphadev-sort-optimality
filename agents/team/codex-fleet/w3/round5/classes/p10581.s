# n=5 model=out iset=I1 prefix14_class=10581
mov S2, P2
mov S0, P3
cmp P3, P0
cmovl P3, P0
cmovle P0, S0
cmp P1, P2
cmovge P2, P1
cmovle S2, P1
cmp P2, P3
mov S1, P0
cmovl S0, P2
cmovle P2, P3
cmovl P3, S0
cmp S2, S1

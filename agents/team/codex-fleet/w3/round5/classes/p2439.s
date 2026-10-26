# n=5 model=out iset=I1 prefix14_class=2439
cmp P1, P0
mov S1, P2
mov S2, P1
cmovge S2, P0
cmovle P1, P0
cmp P2, P3
cmovl S1, P3
cmovl P3, P2
cmovge P2, P3
cmp S1, P1
mov S0, S1
cmovle S0, P1
cmovle P1, S1
mov S0, P1

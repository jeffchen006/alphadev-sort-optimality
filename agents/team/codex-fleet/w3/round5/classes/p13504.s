# n=5 model=out iset=I1 prefix14_class=13504
cmp P1, P0
cmovle S0, P1
cmovl P1, P0
cmovle P0, S0
cmp P2, P3
mov S1, P3
cmovge P3, P2
cmovl S1, P2
cmp S1, P0
cmovle S2, P0
cmovge S2, S1
cmovge S1, P0
mov S1, P3
cmp P1, P3

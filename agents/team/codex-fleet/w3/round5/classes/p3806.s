# n=5 model=out iset=I1 prefix14_class=3806
mov S1, P2
cmp S1, P3
cmovge P2, P3
cmovge P3, S1
cmp P1, P0
cmovle S1, P0
cmovl P0, P1
cmovle P1, S1
cmp P0, P2
cmovl S1, P0
cmovl P0, P2
cmovl P2, S1
mov S0, P1
cmp P3, P1

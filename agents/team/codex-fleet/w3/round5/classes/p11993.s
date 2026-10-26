# n=5 model=out iset=I1 prefix14_class=11993
cmp P0, P1
cmovge S1, P0
cmovge P0, P1
cmovle S1, P1
mov P1, P3
cmp P1, P2
cmovl P3, P2
cmovl P2, P1
cmp P2, P0
cmovl S0, P0
cmovle P0, P2
cmovl P2, S0
cmp S1, P3
mov P1, P2

# n=5 model=out iset=I1 prefix14_class=13495
cmp P0, P1
cmovge S0, P0
cmovle S0, P1
cmovl P1, P0
cmp P2, P3
mov P0, P2
cmovl P0, P3
cmovl P3, P2
cmp P3, P1
cmovle S2, P1
cmovl P1, P3
mov P1, P0
cmovl P3, S2
cmp S0, P1

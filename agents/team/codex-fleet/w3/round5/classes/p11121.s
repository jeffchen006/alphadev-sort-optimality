# n=5 model=out iset=I1 prefix14_class=11121
mov S2, P3
cmp P0, S2
cmovge S2, P0
cmovl P3, P0
mov S1, P2
cmp S1, P1
cmovl P2, P1
cmovle P1, S1
cmp P2, S2
cmovle S1, S2
cmovl S2, P2
cmovle P2, S1
mov P2, S2
mov S0, P3

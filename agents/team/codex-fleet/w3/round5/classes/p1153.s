# n=5 model=out iset=I1 prefix14_class=1153
cmp P3, P0
cmovle S0, P3
mov S2, P2
cmovl P3, P0
cmovl P0, S0
cmp S2, P1
cmovle P2, P1
mov S1, P2
cmovge S2, P1
cmp P2, P3
cmovl S1, P3
cmovle P3, P2
mov P2, P3
mov P1, S2

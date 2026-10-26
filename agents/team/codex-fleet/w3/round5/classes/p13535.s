# n=5 model=out iset=I1 prefix14_class=13535
cmp P1, P3
cmovle S1, P1
cmovge S1, P3
cmovl P1, P3
cmp P2, P0
mov P3, P0
cmovle P3, P2
cmovle P2, P0
cmp S1, P3
cmovle S0, S1
cmovl S1, P3
cmovle P3, S0
mov P3, P1
cmp P1, P2

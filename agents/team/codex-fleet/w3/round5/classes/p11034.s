# n=5 model=out iset=I1 prefix14_class=11034
mov S0, P3
cmp P3, P2
cmovle P3, P2
mov S1, P0
cmovl P2, S0
cmp S1, P1
cmovle S1, P1
cmovle P1, P0
mov P0, P3
cmp S1, P0
cmovl P0, S1
cmovl S1, P3
cmp P1, P2
cmovge S1, P2

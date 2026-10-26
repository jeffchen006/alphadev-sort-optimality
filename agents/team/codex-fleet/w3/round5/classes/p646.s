# n=5 model=out iset=I1 prefix14_class=646
cmp P0, P2
cmovl S1, P0
cmovge S1, P2
cmovl P0, P2
mov P2, P1
cmp P2, P3
cmovg P2, P3
cmovle P1, P3
mov S0, P1
cmp S0, P0
cmovle S0, P0
cmovl P0, P1
cmp P2, S1
mov P1, S1

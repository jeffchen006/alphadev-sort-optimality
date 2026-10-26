# n=5 model=out iset=I1 prefix14_class=8970
cmp P3, P2
cmovge S0, P3
cmovl S0, P2
cmovl P2, P3
cmp P0, P1
cmovle P3, P0
cmovle P0, P1
cmovle P1, P3
mov S1, P0
cmp S0, P0
cmovg P0, S0
cmovle S1, S0
cmp P2, P1
mov P0, P2

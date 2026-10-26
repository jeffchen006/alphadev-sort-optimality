# n=5 model=out iset=I1 prefix14_class=13536
mov S0, P3
cmp S0, P2
mov S1, P0
cmovle P3, P2
cmovge S0, P2
cmp P1, S1
cmovle S1, P1
cmovg P0, P1
cmp S0, S1
cmovl P1, S0
cmovl S0, S1
cmovl S1, P1
cmp P0, P3
cmovle P2, P3

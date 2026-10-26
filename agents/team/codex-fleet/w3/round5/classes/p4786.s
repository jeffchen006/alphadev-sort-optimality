# n=5 model=out iset=I1 prefix14_class=4786
mov S2, P0
cmp S2, P3
cmovle S2, P3
cmovle P3, P0
cmp P2, P1
mov P0, P3
cmovl S0, P2
cmovge S0, P1
cmovg P1, P2
cmp S0, P0
cmovl P3, S0
cmovg P0, S0
cmp P1, S2
cmovle P3, P1

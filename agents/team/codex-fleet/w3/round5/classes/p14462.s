# n=5 model=out iset=I1 prefix14_class=14462
cmp P0, P2
mov S1, P3
cmovge S0, P0
cmovg P0, P2
cmovg P2, S0
cmp S1, P1
cmovge S1, P1
cmovl P3, P1
cmovl P1, S1
cmp S1, P0
cmovle P1, P0
cmovle P0, S1
cmp P2, P3
cmovg P0, P3

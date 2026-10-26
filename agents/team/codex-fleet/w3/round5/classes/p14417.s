# n=5 model=out iset=I1 prefix14_class=14417
mov S1, P0
cmp P1, S1
mov S0, P3
cmovle P0, P1
cmovle P1, S1
cmp S0, P2
cmovl S0, P2
cmovle P2, P3
cmp P0, P2
cmovg P3, P0
cmovg P0, P2
cmovg P2, P3
cmp P1, S0
cmovge S1, P1

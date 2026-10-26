# n=5 model=out iset=I1 prefix14_class=5602
mov S1, P2
cmp S1, P0
mov S0, P3
cmovle P2, P0
cmovg S1, P0
cmp P3, P1
mov P0, S1
cmovle P3, P1
cmovle P1, S0
cmp P0, P1
cmovge S1, P1
cmovg P1, P0
cmp P2, P3
cmovl S1, P2

# n=5 model=out iset=I1 prefix14_class=1710
cmp P3, P1
cmovl S2, P1
cmovle P1, P3
cmovge S2, P3
cmp P2, P0
cmovle P3, P0
cmovle P0, P2
mov S0, P0
cmovle P2, P3
cmp P1, P0
cmovge S0, P1
cmovle P0, P1
mov P3, S0
cmp P2, S2

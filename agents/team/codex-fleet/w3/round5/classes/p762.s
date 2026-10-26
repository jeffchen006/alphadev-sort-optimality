# n=5 model=out iset=I1 prefix14_class=762
cmp P2, P1
cmovl S1, P2
cmovge S1, P1
cmovle P2, P1
mov S0, P0
cmp P0, P3
cmovl S0, P3
cmovg P0, P3
cmp S0, P2
mov P1, P2
cmovle P2, S0
cmovge P1, S0
mov P1, P0
cmp P1, S1

# n=5 model=out iset=I1 prefix14_class=6905
mov S0, P0
cmp P1, P0
cmovl S0, P1
cmovge P0, P1
mov P1, P2
cmp P2, P3
cmovg P2, P3
mov S1, P0
cmovle P1, P3
cmp P1, P0
cmovle P0, P1
cmovge S1, P1
cmp S0, P2
cmovl P1, P2

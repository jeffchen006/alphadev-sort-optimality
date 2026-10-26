# n=5 model=out iset=I1 prefix14_class=12851
mov S1, P3
cmp P0, P1
cmovl S0, P1
cmovle P1, P0
mov S2, P1
cmovl P0, S0
cmp S1, P2
cmovl P3, P2
cmovle P2, S1
cmp P1, P2
cmovl S2, P2
cmovle P2, P1
cmp P0, P3
cmovge P2, P3

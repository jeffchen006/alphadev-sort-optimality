# n=5 model=out iset=I1 prefix14_class=1618
mov S0, P3
cmp S0, P1
cmovge S0, P1
cmovl P3, P1
cmp P2, P0
mov P1, P0
cmovl P1, P2
cmovg P0, P2
cmp S0, P1
cmovle P2, P1
cmovle P1, S0
mov S2, P3
cmovl S0, P2
cmp P0, P3

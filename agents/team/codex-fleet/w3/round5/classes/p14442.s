# n=5 model=out iset=I1 prefix14_class=14442
cmp P3, P2
cmovl S1, P2
cmovge S1, P3
mov S0, P0
cmovle P2, P3
cmp S0, P1
cmovl P0, P1
cmovg S0, P1
cmp S0, P2
cmovle P1, P2
cmovle P2, S0
cmovl S0, P1
mov S2, S1
mov P3, S0

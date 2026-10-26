# n=5 model=out iset=I1 prefix14_class=5061
mov S1, P2
cmp P0, P2
cmovg S1, P0
cmovl P2, P0
mov S0, P1
cmp P3, S0
cmovge S0, P3
mov S2, P2
cmovle P1, P3
cmp S2, P1
mov P3, S1
cmovl P2, P1
cmovg S2, P1
mov P1, P2

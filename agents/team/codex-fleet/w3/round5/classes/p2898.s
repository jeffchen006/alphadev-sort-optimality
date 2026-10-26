# n=5 model=out iset=I1 prefix14_class=2898
cmp P0, P3
mov S0, P1
mov S1, P0
cmovge S1, P3
cmovle P0, P3
cmp S0, P2
cmovg S0, P2
cmovl P1, P2
cmp P0, P1
mov P3, P0
cmovl P3, P1
cmovl P1, P0
cmp S0, S1
mov S2, P1

# n=5 model=out iset=I1 prefix14_class=1959
cmp P2, P1
mov S1, P2
cmovl P2, P1
mov S0, P0
cmovge S1, P1
cmp P3, S0
cmovg S0, P3
cmovl P0, P3
mov P3, P2
cmp S0, P3
cmovle P3, S0
cmovg P2, S0
cmp P0, S1
cmovl S0, P0

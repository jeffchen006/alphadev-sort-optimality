# n=5 model=out iset=I1 prefix14_class=4932
mov S0, P3
mov S2, P1
cmp S0, P0
cmovl P3, P0
cmovge S0, P0
cmp S2, P2
cmovl P1, P2
cmovle P2, S2
cmp S0, P2
mov S1, P1
cmovg S2, S0
cmovg S0, P2
cmovg P2, S2
cmp P1, P3

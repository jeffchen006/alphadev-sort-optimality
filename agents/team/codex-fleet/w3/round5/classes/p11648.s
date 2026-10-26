# n=5 model=out iset=I1 prefix14_class=11648
mov S1, P1
cmp P3, P2
mov S0, P2
cmovl P2, P3
cmovg S0, P3
cmp S1, P0
cmovg S1, P0
mov S2, S0
cmovle P1, P0
cmp P1, S2
cmovl S2, P1
cmovge S0, P1
cmp S1, P2
cmovl P3, P2

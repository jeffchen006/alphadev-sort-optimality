# n=5 model=out iset=I1 prefix14_class=12667
cmp P3, P1
cmovl S1, P1
cmovle P1, P3
cmovge S1, P3
mov S0, P1
cmp P2, P0
cmovl P3, P0
mov S2, S1
cmovl P0, P2
cmovl P2, P3
cmp P1, P0
cmovg S0, P0
cmovl P1, P0
cmp S2, P2

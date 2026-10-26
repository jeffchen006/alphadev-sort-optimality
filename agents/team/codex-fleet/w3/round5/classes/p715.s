# n=5 model=out iset=I1 prefix14_class=715
cmp P3, P2
cmovl S0, P3
cmovge S0, P2
mov S2, P1
cmovle P3, P2
cmp P1, P0
cmovg S2, P0
cmovl P1, P0
cmp P3, P1
mov S1, P3
cmovl P3, P1
cmovl P1, S1
cmp S0, S2
cmovg P3, S0

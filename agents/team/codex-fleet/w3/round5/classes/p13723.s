# n=5 model=out iset=I1 prefix14_class=13723
cmp P1, P3
cmovl S2, P3
mov S0, P0
cmovl P3, P1
cmovl P1, S2
cmp P0, P2
cmovg S0, P2
cmovle P0, P2
cmp P0, P1
cmovge S2, P1
cmovg P1, P0
cmovg P0, S2
cmp P3, S0
mov S1, P3

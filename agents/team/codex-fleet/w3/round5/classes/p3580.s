# n=5 model=out iset=I1 prefix14_class=3580
cmp P1, P3
mov S0, P1
cmovle P1, P3
cmovl P3, S0
mov S2, P2
cmp P0, P2
cmovle P2, P0
cmovge S2, P0
mov S1, P3
cmp P2, P3
cmovl S1, P2
cmovg P3, P2
mov S1, S2
cmp S2, P1

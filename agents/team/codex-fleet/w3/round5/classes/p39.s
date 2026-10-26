# n=5 model=out iset=I1 prefix14_class=39
cmp P3, P1
cmovle S1, P1
mov S0, P2
cmovle P1, P3
cmovl P3, S1
cmp P0, P2
mov S2, P1
cmovl S0, P0
cmovg P2, P0
cmp S2, S0
cmovge S2, S0
cmovle P1, S0
cmp P3, P2
cmovge S1, P3

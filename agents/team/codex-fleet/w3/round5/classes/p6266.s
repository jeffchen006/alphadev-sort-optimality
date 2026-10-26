# n=5 model=out iset=I1 prefix14_class=6266
cmp P1, P0
cmovl S2, P0
cmovle P0, P1
mov S0, P3
cmovl P1, S2
cmp P2, P3
cmovge S0, P2
mov S1, P1
cmovle P3, P2
cmp S0, S1
cmovl P1, S0
cmovle S0, S1
cmp P3, P0
mov S0, P3

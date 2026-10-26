# n=5 model=out iset=I1 prefix14_class=13656
cmp P1, P2
mov S2, P2
cmovge S2, P1
cmovl P2, P1
cmp P3, P0
cmovle P1, P3
cmovl P3, P0
cmovl P0, P1
cmp S2, P3
mov S0, S2
cmovle S2, P3
cmovge S0, P3
cmp P0, P2
cmovl S2, P0

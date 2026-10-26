# n=5 model=out iset=I1 prefix14_class=13538
mov S0, P3
cmp S0, P0
cmovle P3, P0
cmovge S0, P0
cmp P1, P2
mov S1, P2
cmovle P2, P1
cmovge S1, P1
cmp S0, P2
cmovl P1, S0
cmovl S0, P2
cmovl P2, P1
cmp S1, P3
cmovle S2, P3

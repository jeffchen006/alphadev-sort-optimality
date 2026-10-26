# n=5 model=out iset=I1 prefix14_class=12509
mov S0, P0
mov S2, P3
cmp S0, P1
cmovle S0, P1
cmovl P1, P0
cmp P2, S2
cmovl P3, P2
cmovge S2, P2
cmp P1, P3
cmovle P0, P1
cmovl P1, P3
mov P2, P1
cmovle P3, P0
cmp S0, S2

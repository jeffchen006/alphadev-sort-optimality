# n=5 model=out iset=I1 prefix14_class=12361
cmp P1, P3
cmovle S2, P3
cmovle P3, P1
cmovle P1, S2
cmp P0, P2
mov S1, P3
cmovge S0, P0
cmovg P0, P2
cmovl S0, P2
cmp S1, P0
cmovl P3, P0
cmovle P0, S1
mov P0, S0
cmp S0, P1

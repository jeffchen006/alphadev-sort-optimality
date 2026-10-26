# n=5 model=out iset=I1 prefix14_class=12561
cmp P3, P0
mov S2, P0
cmovg P0, P3
cmovg P3, S2
cmp P1, P2
cmovl S0, P1
cmovl P1, P2
cmovge S0, P2
cmp S0, P3
mov S2, P1
cmovle S1, P3
cmovle P3, S0
cmovle S0, S1
mov P3, S0

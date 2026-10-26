# n=5 model=out iset=I1 prefix14_class=5227
mov S0, P2
cmp S0, P3
mov S1, P1
cmovle S0, P3
cmovg P2, P3
cmp P0, P1
cmovle S1, P0
cmovle P0, P1
cmp P2, S1
cmovl S2, P2
cmovl P2, S1
cmovge S2, S1
mov P3, P2
mov S2, P0

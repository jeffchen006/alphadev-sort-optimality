# n=5 model=out iset=I1 prefix14_class=1157
cmp P3, P1
mov S2, P3
mov S0, P2
cmovle P3, P1
cmovl P1, S2
cmp S0, P0
cmovl S0, P0
cmovg P2, P0
mov S1, S0
cmp S1, P3
mov P0, P1
cmovle S0, P3
cmovge S1, P3
cmovl P3, S1

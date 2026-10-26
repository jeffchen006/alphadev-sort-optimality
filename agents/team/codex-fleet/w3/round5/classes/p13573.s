# n=5 model=out iset=I1 prefix14_class=13573
mov S2, P1
mov S0, P0
cmp P1, P3
cmovle S2, P3
cmovl P3, P1
cmp P0, P2
cmovg P0, P2
cmovl S0, P2
mov S1, P3
cmp S1, P0
cmovle P3, P0
cmovge S1, P0
cmp S2, S0
cmovle S1, S2

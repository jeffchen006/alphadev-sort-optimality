# n=5 model=out iset=I1 prefix14_class=3728
cmp P2, P3
cmovge S1, P2
mov S0, P1
cmovl S1, P3
cmovle P3, P2
cmp P0, S0
cmovg P1, P0
cmovge P0, S0
cmp P0, P3
cmovge S0, P0
cmovle S0, P3
cmovl P3, P0
cmp S1, P1
mov S2, S0

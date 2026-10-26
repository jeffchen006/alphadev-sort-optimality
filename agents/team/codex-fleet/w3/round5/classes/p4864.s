# n=5 model=out iset=I1 prefix14_class=4864
mov S1, P0
cmp S1, P1
cmovge S1, P1
cmovg P1, P0
cmp P2, P3
cmovge S2, P2
cmovle S2, P3
cmovg P2, P3
cmp P2, S1
cmovl P3, P2
cmovle P2, S1
cmovl S1, P3
mov S0, P1
cmp S2, P1

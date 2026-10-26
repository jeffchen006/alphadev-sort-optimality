# n=5 model=out iset=I1 prefix14_class=2661
mov S1, P0
cmp P2, P0
cmovle P0, P2
mov S2, P0
cmovge S1, P2
cmp P3, P1
cmovle S0, P3
cmovg S0, P1
cmovg P1, P3
cmp S1, P1
cmovle P3, P1
cmovl P1, S1
cmovl S1, P3
cmp S0, P0

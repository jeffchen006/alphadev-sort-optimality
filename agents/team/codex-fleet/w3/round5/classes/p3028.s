# n=5 model=out iset=I1 prefix14_class=3028
mov S0, P1
cmp S0, P2
cmovl S0, P2
cmovl P2, P1
cmp P0, P3
cmovge S1, P0
cmovg P0, P3
cmovle S1, P3
mov P3, S1
cmp S0, P3
cmovle P3, S0
cmovg S1, S0
cmp P0, P2
cmovle P1, P2

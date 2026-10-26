# n=5 model=out iset=I1 prefix14_class=7288
cmp P2, P0
mov S2, P0
cmovge S2, P2
cmovl P0, P2
cmp P1, P3
cmovl S1, P3
cmovle P3, P1
mov S0, P3
cmovl P1, S1
cmp S0, P0
cmovg S0, P0
cmovg P0, P3
cmp S2, P1
cmovle S1, P1

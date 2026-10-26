# n=5 model=out iset=I1 prefix14_class=12679
cmp P3, P1
mov S1, P0
cmovg S0, P1
cmovg P1, P3
cmovg P3, S0
cmp P2, S1
cmovl S1, P2
cmovl P2, P0
mov P0, P3
cmp S1, P0
cmovle P3, S1
cmovle S1, P0
cmp P1, P2
cmovge S0, P2

# n=5 model=out iset=I1 prefix14_class=14019
cmp P3, P1
cmovl S1, P3
cmovge S1, P1
cmovg P1, P3
cmp P0, P2
mov S0, S1
mov S2, P1
cmovl P3, P0
cmovle P0, P2
cmovl P2, P3
cmp P1, P0
cmovg P1, P0
cmovle S2, P0
cmp S0, P2

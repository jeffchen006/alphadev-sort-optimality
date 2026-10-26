# n=5 model=out iset=I1 prefix14_class=7030
mov S2, P1
cmp P2, P1
mov S1, P3
cmovge S2, P2
cmovg P2, P1
mov S0, P2
cmp S1, P0
cmovl S1, P0
cmovg P3, P0
cmp P3, P2
cmovle S0, P3
cmovle P3, P2
cmp S1, S2
cmovl P1, S2

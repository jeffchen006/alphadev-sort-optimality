# n=5 model=out iset=I1 prefix14_class=2437
mov S2, P1
cmp P2, P3
cmovle S0, P2
cmovl P2, P3
cmovge S0, P3
cmp P1, P0
cmovl S2, P0
cmovl P0, P1
cmp S2, P2
cmovle P1, P2
cmovl P2, S2
cmovg P1, S2
cmp P0, S0
cmovg S2, P2

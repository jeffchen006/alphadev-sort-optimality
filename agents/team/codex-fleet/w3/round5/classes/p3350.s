# n=5 model=out iset=I1 prefix14_class=3350
cmp P1, P3
cmovle S2, P3
cmovl P3, P1
cmovg S2, P1
cmp P0, P2
cmovge S0, P2
cmovl S0, P0
cmovg P2, P0
mov P1, P3
cmp P1, S0
cmovg P3, S0
cmovg S0, P1
cmp S2, P2
cmovle P3, P2

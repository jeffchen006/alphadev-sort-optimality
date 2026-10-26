# n=5 model=out iset=I1 prefix14_class=7355
cmp P1, P2
cmovge S2, P2
cmovg P2, P1
cmovl S2, P1
cmp P3, P0
cmovle S0, P0
cmovle P0, P3
cmovl P3, S0
mov P1, P0
cmp P1, S2
cmovle P1, S2
cmovl S2, P0
cmp P3, P2
cmovg S0, P3

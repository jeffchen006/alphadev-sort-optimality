# n=5 model=out iset=I1 prefix14_class=7228
cmp P1, P3
cmovge S0, P1
cmovle S0, P3
cmovg P1, P3
cmp P0, P2
cmovg P3, P2
cmovg P2, P0
cmovg P0, P3
mov S2, S0
cmp P1, P0
cmovle P3, P0
cmovl P0, P1
cmovle P1, P3
cmp P2, S0

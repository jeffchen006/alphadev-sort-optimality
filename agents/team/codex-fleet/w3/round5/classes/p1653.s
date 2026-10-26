# n=5 model=out iset=I1 prefix14_class=1653
cmp P3, P2
cmovg S0, P3
cmovg P3, P2
cmovle S0, P2
mov S1, S0
cmovl P2, P3
cmp P1, P0
cmovge S2, P0
cmovg P0, P1
cmovle S2, P1
cmp P2, S2
cmovle P2, S2
cmovl S2, P3
cmovle P3, P2

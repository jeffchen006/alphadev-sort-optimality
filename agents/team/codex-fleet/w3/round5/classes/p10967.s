# n=5 model=out iset=I1 prefix14_class=10967
cmp P3, P1
cmovle S2, P3
cmovl P3, P1
cmovl P1, S2
cmp P0, P2
cmovg S0, P0
cmovg P0, P2
cmovg P2, S0
cmp P2, P3
mov S1, P3
cmovle P3, P2
cmovge S1, P2
cmp P1, P0
cmovl P2, P0

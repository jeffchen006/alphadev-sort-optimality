# n=5 model=out iset=I1 prefix14_class=11839
cmp P1, P0
cmovle S0, P1
cmovle P1, P0
cmovl P0, S0
cmp P3, P2
cmovl S0, P3
cmovle P3, P2
mov S2, P1
cmovl P2, S0
mov S1, P0
cmp P3, S2
cmovle S2, P3
cmovg P1, P3
cmp P2, P0

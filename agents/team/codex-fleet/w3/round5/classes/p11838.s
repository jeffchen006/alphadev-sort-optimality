# n=5 model=out iset=I1 prefix14_class=11838
cmp P0, P1
cmovle S0, P0
cmovle P0, P1
cmovl P1, S0
cmp P3, P2
cmovl S0, P3
cmovle P3, P2
mov S2, P0
cmovl P2, S0
cmp P3, S2
mov S1, P1
cmovg P0, P3
cmovle S2, P3
cmp P2, P1

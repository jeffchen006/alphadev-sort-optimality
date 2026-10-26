# n=5 model=out iset=I1 prefix14_class=3622
cmp P2, P3
mov S0, P1
cmovle S2, P2
cmovl P2, P3
cmovle P3, S2
cmp P0, S0
cmovle P1, P0
cmovle P0, S0
cmovle S0, P1
cmp P3, S0
cmovl S0, P3
cmovg P1, P3
cmp P0, P2
mov S0, P0

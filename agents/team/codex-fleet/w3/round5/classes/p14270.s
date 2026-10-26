# n=5 model=out iset=I1 prefix14_class=14270
cmp P0, P3
mov S0, P3
cmovle P3, P0
cmovl P0, S0
cmp P1, P2
cmovle S2, P2
cmovle P2, P1
mov S0, P0
cmovle P1, S2
cmp P0, P1
cmovl S0, P1
cmovle P1, P0
mov S0, P1
cmp P3, P2

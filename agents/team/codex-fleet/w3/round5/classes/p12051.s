# n=5 model=out iset=I1 prefix14_class=12051
cmp P1, P3
mov S0, P1
cmovle S0, P3
cmovle P3, P1
cmp P0, P2
cmovle P1, P0
cmovl P0, P2
cmovle P2, P1
cmp P2, P3
mov S2, P2
cmovl P2, P3
cmovle P3, S2
cmp P0, S0
cmovl S2, P2

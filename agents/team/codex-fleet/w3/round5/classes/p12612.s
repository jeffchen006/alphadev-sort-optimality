# n=5 model=out iset=I1 prefix14_class=12612
mov S0, P3
cmp P1, S0
cmovle S0, P1
cmovle P1, P3
cmp P0, P2
cmovl S2, P2
cmovl P2, P0
cmovl P0, S2
cmp P2, S0
cmovle S2, S0
cmovle S0, P2
cmovle P2, S2
mov S0, P1
cmp P0, P1

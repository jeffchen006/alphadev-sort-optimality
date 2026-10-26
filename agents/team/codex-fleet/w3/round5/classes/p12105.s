# n=5 model=out iset=I1 prefix14_class=12105
mov S0, P0
cmp P2, P1
cmovle S1, P1
cmovle P1, P2
cmovl P2, S1
cmp P3, S0
cmovle S0, P3
cmovle P3, P0
mov S2, S0
cmp P1, S2
cmovl S2, P1
cmovle P1, S0
mov P0, P3
cmp P0, P2

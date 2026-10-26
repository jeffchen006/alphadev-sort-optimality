# n=5 model=out iset=I1 prefix14_class=11128
cmp P1, P0
mov S0, P2
mov S2, P1
cmovl P1, P0
cmovle P0, S2
cmp P3, S0
cmovle P2, P3
cmovle P3, S0
cmp P1, P3
cmovle S1, P1
cmovle P1, P3
cmovle P3, S1
mov P1, P3
cmp P0, P2

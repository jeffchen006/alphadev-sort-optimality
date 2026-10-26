# n=5 model=out iset=I1 prefix14_class=4920
mov S0, P2
mov S1, P0
cmp P1, P2
cmovle P2, P1
cmovl P1, S0
cmp P0, P3
mov S0, P2
cmovle P0, P3
cmovl P3, S1
cmp P3, S0
cmovle S0, P3
cmovle P3, P2
mov S2, P1
mov S0, P3

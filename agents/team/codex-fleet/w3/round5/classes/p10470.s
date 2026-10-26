# n=5 model=out iset=I1 prefix14_class=10470
mov S1, P1
cmp P2, P0
cmovle S2, P0
cmovl P0, P2
cmovle P2, S2
cmp P3, P1
cmovle S1, P3
cmovl P3, P1
mov S0, S1
cmp P3, P2
mov P1, P2
cmovl P2, P3
cmovl P3, P1
mov P3, P2

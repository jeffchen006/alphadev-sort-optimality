# n=5 model=out iset=I1 prefix14_class=13109
cmp P3, P0
mov S1, P0
cmovle P0, P3
cmovl P3, S1
cmp P1, P2
cmovle S1, P1
cmovl P1, P2
cmovle P2, S1
mov S2, P2
cmp P2, P0
cmovl P2, P0
cmovle P0, S2
mov S2, P2
mov S0, P3

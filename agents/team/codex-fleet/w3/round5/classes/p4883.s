# n=5 model=out iset=I1 prefix14_class=4883
cmp P2, P1
cmovle S2, P1
mov S1, P3
cmovl P1, P2
cmovle P2, S2
cmp P0, P3
cmovl P3, P0
cmovl P0, S1
cmp P3, P1
mov S1, P3
cmovle P3, P1
cmovg S1, P1
mov S1, P2
cmp P0, P2

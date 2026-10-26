# n=5 model=out iset=I1 prefix14_class=12413
mov S1, P0
cmp P0, P1
cmovle P0, P1
cmovle P1, S1
cmp P3, P2
mov S1, P2
cmovle P2, P3
cmovl P3, S1
cmp P1, P2
mov S1, P2
cmovl P2, P1
cmovl P1, S1
cmp P0, P3
cmovle S0, P0

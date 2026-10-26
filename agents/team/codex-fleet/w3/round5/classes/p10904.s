# n=5 model=out iset=I1 prefix14_class=10904
cmp P3, P0
mov S1, P1
mov S0, P3
cmovle P3, P0
cmovl P0, S0
cmp P2, P1
cmovg P1, P2
cmovle S1, P2
cmp P1, P3
cmovle P2, P1
cmovl P1, P3
cmovl P3, P2
cmp P0, S1
cmovle P2, S1

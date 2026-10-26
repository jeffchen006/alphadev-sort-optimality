# n=5 model=out iset=I1 prefix14_class=11804
cmp P1, P2
cmovle S2, P2
cmovle P2, P1
cmovle P1, S2
cmp P0, P3
cmovl S0, P0
cmovle P0, P3
cmovl P3, S0
mov S1, P1
cmp P0, S1
cmovle S1, P0
cmovg P1, P0
mov P1, P3
cmp P3, P2

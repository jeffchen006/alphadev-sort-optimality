# n=5 model=out iset=I1 prefix14_class=8925
cmp P2, P0
cmovle S0, P0
cmovle P0, P2
cmovl P2, S0
mov S1, P1
cmp P3, S1
cmovle S1, P3
cmovl P3, P1
cmp P2, P3
cmovle P1, P2
cmovg P1, P3
cmovl P2, P3
cmp P0, S1
mov P2, P1

# n=5 model=out iset=I1 prefix14_class=6180
mov S0, P2
cmp P3, P2
cmovle S0, P3
cmovl P3, P2
mov P2, P0
cmp P1, P0
cmovl P0, P1
cmovg P2, P1
cmp P2, P3
cmovle P1, P2
cmovle P2, P3
mov S1, P0
cmovl P3, P1
mov S2, P3

# n=5 model=out iset=I1 prefix14_class=2142
cmp P1, P0
cmovle S2, P0
cmovle P0, P1
cmovl P1, S2
mov S2, P1
mov S1, P3
cmp P2, S1
cmovle P3, P2
cmovle P2, S1
cmp P1, P2
cmovl S2, P2
cmovle P2, P1
cmp P3, P0
mov S2, P3

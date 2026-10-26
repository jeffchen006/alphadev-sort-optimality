# n=5 model=out iset=I1 prefix14_class=12847
mov S1, P1
cmp P0, P1
cmovle P1, P0
cmovl P0, S1
cmp P3, P2
cmovle S1, P3
cmovle P3, P2
cmovl P2, S1
cmp P2, P1
cmovle S2, P2
mov S1, P0
cmovl P2, P1
cmovle P1, S2
cmp P3, S1

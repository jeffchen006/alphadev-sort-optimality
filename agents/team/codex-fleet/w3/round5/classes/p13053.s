# n=5 model=out iset=I1 prefix14_class=13053
mov S2, P2
cmp P0, P2
cmovg P2, P0
cmovl S2, P0
cmp P1, P3
cmovle P0, P1
cmovle P1, P3
cmovl P3, P0
mov S1, P3
cmp P3, S2
cmovl S1, S2
cmovle S2, P3
cmp P2, P1
cmovle P0, P1

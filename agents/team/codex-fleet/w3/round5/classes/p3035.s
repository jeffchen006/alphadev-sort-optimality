# n=5 model=out iset=I1 prefix14_class=3035
mov S2, P2
mov S1, P1
cmp P3, S2
cmovle P2, P3
cmovl P3, S2
cmp P0, S1
cmovle S1, P0
cmovg P1, P0
mov P0, P2
cmp P0, S1
cmovle P2, S1
cmovle S1, P0
cmp P3, P1
mov S1, P1

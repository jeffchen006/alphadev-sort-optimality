# n=5 model=out iset=I1 prefix14_class=8544
cmp P2, P3
cmovle S2, P2
cmovle P2, P3
cmovl P3, S2
cmp P0, P1
mov S1, P1
cmovl P1, P0
cmovg S1, P0
cmovl P0, S1
cmp P2, S1
cmovg P0, P2
cmovle S1, P2
mov P2, P1
cmp P3, P1

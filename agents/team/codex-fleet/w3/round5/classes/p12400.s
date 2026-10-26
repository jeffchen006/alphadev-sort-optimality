# n=5 model=out iset=I1 prefix14_class=12400
mov S2, P1
mov S1, P3
cmp P0, P3
cmovg S1, P0
cmovl P3, P0
cmp P2, P1
cmovg P1, P2
cmovle S2, P2
cmp P3, S2
cmovle P2, S2
cmovle S2, P3
cmovle P3, P2
cmp P1, S1
cmovle S0, S1

# n=5 model=out iset=I1 prefix14_class=14501
cmp P2, P1
cmovg S2, P2
cmovg P2, P1
cmovg P1, S2
mov S1, P2
mov S0, P3
cmp P0, P3
cmovle P3, P0
cmovl P0, S0
cmp P2, P3
cmovl P2, P3
cmovle P3, S1
cmp P0, P1
cmovle S2, P0

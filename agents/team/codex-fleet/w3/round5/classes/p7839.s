# n=5 model=out iset=I1 prefix14_class=7839
mov S2, P3
cmp P3, P2
cmovg S2, P2
cmovl P3, P2
cmovle P2, S2
cmp P0, P1
cmovle S0, P1
cmovle P1, P0
cmovl P0, S0
cmp P1, P2
cmovle P2, P1
cmovg S2, P1
mov S1, S2
cmp P3, P0

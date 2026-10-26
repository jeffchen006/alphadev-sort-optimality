# n=5 model=out iset=I1 prefix14_class=7262
cmp P1, P2
cmovle S1, P1
mov S2, P0
cmovl P1, P2
cmovl P2, S1
mov S0, P2
cmp P3, S2
cmovle S2, P3
cmovle P3, P0
cmp P2, S2
cmovle P2, S2
cmovg S0, S2
mov S2, P2
cmp P1, P3

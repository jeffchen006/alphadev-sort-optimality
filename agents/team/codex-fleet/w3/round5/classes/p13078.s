# n=5 model=out iset=I1 prefix14_class=13078
mov S2, P0
cmp P2, S2
cmovg P0, P2
cmovg P2, S2
mov S0, P2
cmp P3, P1
cmovle S2, P3
cmovl P3, P1
cmovle P1, S2
cmp P1, S0
cmovg P2, P1
cmovle S0, P1
cmp P0, P3
cmovg S1, P3

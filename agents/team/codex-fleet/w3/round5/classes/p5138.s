# n=5 model=out iset=I1 prefix14_class=5138
mov S1, P0
cmp P2, P0
cmovg S1, P2
cmovle P0, P2
cmp P1, P3
mov S2, P0
cmovle S0, P3
cmovl P3, P1
cmovle P1, S0
cmp P0, P3
cmovg S2, P3
cmovg P3, P0
mov S2, S1
cmp P1, S2

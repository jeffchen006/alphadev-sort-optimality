# n=5 model=out iset=I1 prefix14_class=11650
mov S2, P1
cmp P0, P2
cmovle S1, P2
cmovle P2, P0
cmovl P0, S1
cmp S2, P3
cmovle P1, P3
cmovl P3, S2
mov S0, P0
cmp P1, P0
cmovle P0, P1
cmovg S0, P1
cmp P3, P2
cmovle S1, P3

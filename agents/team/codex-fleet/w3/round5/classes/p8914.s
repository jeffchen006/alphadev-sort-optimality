# n=5 model=out iset=I1 prefix14_class=8914
cmp P0, P1
mov S1, P3
cmovle S0, P0
cmovg S0, P1
cmovl P0, P1
cmp P2, P3
cmovle P3, P2
cmovle P2, S1
mov S2, P3
cmp P2, P0
cmovle P1, P2
cmovle P2, P0
cmovle P0, P1
cmp S0, S2

# n=5 model=out iset=I1 prefix14_class=5131
mov S2, P2
mov S1, P0
cmp P0, P3
cmovle S1, P3
cmovle P3, P0
cmp P1, S2
cmovl S2, P1
mov S0, S2
cmovle P1, P2
cmp P3, S2
cmovg S0, P3
cmovle S2, P3
cmp P1, S1
cmovle P2, P1

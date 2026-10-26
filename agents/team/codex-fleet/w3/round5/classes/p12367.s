# n=5 model=out iset=I1 prefix14_class=12367
mov S0, P3
cmp P1, P3
cmovle P3, P1
cmovle P1, S0
cmp P0, P2
cmovg S0, P0
cmovle S0, P2
cmovg P0, P2
cmp P3, P0
cmovle S2, P3
cmovle P3, P0
cmovl P0, S2
mov P0, S0
cmp P0, P1

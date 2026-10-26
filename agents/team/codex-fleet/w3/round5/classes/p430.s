# n=5 model=out iset=I1 prefix14_class=430
mov S0, P3
cmp P2, P0
cmovg S1, P2
cmovle S1, P0
cmovle P0, P2
cmp P3, P1
cmovg S0, P1
cmovg P1, P3
cmp P0, S0
mov P2, P0
cmovg P2, S0
cmovle P0, S0
cmp P1, S1
cmovle S0, P1

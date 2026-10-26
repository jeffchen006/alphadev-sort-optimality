# n=5 model=out iset=I1 prefix14_class=12398
mov S2, P3
cmp P2, P3
cmovg S2, P2
cmovle P3, P2
cmp P0, P1
mov S1, P1
cmovg P1, P0
cmovle S1, P0
cmp P3, S1
cmovle P0, S1
cmovle S1, P3
cmovle P3, P0
cmp P1, S2
mov S0, S2

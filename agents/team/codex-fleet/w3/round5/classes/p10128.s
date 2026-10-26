# n=5 model=out iset=I1 prefix14_class=10128
mov S0, P1
cmp P1, P3
cmovg S0, P3
cmovg P3, P1
cmp P0, P2
cmovle S1, P0
cmovle P0, P2
cmovle P2, S1
mov S2, P0
cmp P0, P3
cmovg S2, P3
cmovle P0, P3
cmp P2, S0
cmovle S1, P2

# n=5 model=out iset=I1 prefix14_class=3620
cmp P2, P3
mov S0, P1
mov S2, P2
cmovle P2, P3
cmovle P3, S2
cmp P0, P1
cmovle S0, P0
cmovle P0, P1
cmovle P1, S0
cmp P3, P1
cmovle P1, P3
cmovg S0, P3
cmp P0, P2
cmovle S2, P0

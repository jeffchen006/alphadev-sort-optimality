# n=5 model=out iset=I1 prefix14_class=12175
cmp P3, P0
cmovle S0, P0
cmovle P0, P3
cmovle P3, S0
cmp P1, P2
cmovg S2, P1
cmovle S2, P2
cmovg P1, P2
mov P2, P0
cmp P1, P0
cmovg P0, P1
cmovle P2, P1
cmp P3, S2
cmovle S1, P3

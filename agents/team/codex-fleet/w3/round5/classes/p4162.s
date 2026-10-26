# n=5 model=out iset=I1 prefix14_class=4162
cmp P3, P2
cmovg S2, P2
cmovg P2, P3
cmovle S2, P3
cmp P0, P1
mov S1, P0
mov S0, S2
cmovle S1, P1
cmovle P1, P0
cmp P1, S0
cmovg S2, P1
cmovle S0, P1
cmp P2, S1
mov P1, S2

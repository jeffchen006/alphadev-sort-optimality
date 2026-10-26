# n=5 model=out iset=I1 prefix14_class=8804
mov S1, P3
cmp P3, P1
cmovle P3, P1
mov S0, P0
cmovle P1, S1
cmp P2, P0
cmovg P0, P2
cmovle S0, P2
cmp P0, P3
mov S2, P3
cmovg P3, P0
cmovg P0, S2
cmp P1, S0
cmovle S2, P1

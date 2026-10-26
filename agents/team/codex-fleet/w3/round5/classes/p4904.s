# n=5 model=out iset=I1 prefix14_class=4904
mov S0, P0
cmp S0, P3
cmovle S0, P3
cmovle P3, P0
mov S1, P2
cmp P1, S1
cmovle P2, P1
cmovle P1, S1
cmp P3, P2
mov S2, P3
cmovg P3, P2
cmovle S2, P2
cmp S0, P1
cmovle P3, S0

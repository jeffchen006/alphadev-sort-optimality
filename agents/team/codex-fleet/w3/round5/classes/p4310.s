# n=5 model=out iset=I1 prefix14_class=4310
mov S2, P0
cmp P0, P2
mov S0, P3
cmovle P0, P2
cmovg S2, P2
cmp S0, P1
cmovg S0, P1
cmovle P3, P1
cmp S2, S0
cmovle P2, S2
mov P1, P0
cmovle S2, S0
cmovle S0, P2
cmp P3, P1

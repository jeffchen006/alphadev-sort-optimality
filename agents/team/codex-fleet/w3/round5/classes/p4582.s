# n=5 model=out iset=I1 prefix14_class=4582
mov S0, P0
cmp P2, P1
cmovle S2, P1
cmovg S2, P2
cmovle P1, P2
cmp P3, S0
cmovle S0, P3
cmovle P3, P0
mov P0, S2
cmp P3, S2
cmovle P0, P3
cmovle P3, S2
mov P3, P0
cmp S0, P1

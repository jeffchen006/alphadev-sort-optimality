# n=5 model=out iset=I1 prefix14_class=701
cmp P3, P2
cmovle S0, P3
cmovle P3, P2
cmovg S0, P2
mov P2, P0
mov S1, P3
cmp P2, P1
cmovle P0, P1
cmovg P2, P1
cmp S1, P0
cmovle S1, P0
cmovle P0, P3
mov S2, P0
mov P3, S0

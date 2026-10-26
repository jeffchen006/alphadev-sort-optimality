# n=5 model=out iset=I1 prefix14_class=700
cmp P3, P2
cmovle S0, P3
cmovle P3, P2
cmovg S0, P2
mov P2, P1
mov S1, P3
cmp P2, P0
cmovle P1, P0
cmovg P2, P0
cmp S1, P1
cmovle S1, P1
cmovle P1, P3
mov S2, P1
mov P3, S0

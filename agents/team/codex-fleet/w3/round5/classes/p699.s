# n=5 model=out iset=I1 prefix14_class=699
cmp P3, P1
cmovle S0, P3
cmovle P3, P1
cmovg S0, P1
mov P1, P2
mov S1, P3
cmp P1, P0
cmovle P2, P0
cmovg P1, P0
cmp S1, P2
cmovle S1, P2
cmovle P2, P3
mov P3, S0
mov S2, P2

# n=5 model=out iset=I1 prefix14_class=2895
mov S2, P2
cmp P2, P0
cmovle S2, P0
cmovle P0, P2
mov P2, P3
cmp P2, P1
cmovle P3, P1
cmovg P2, P1
cmp S2, P3
mov S0, S2
cmovg S0, P3
cmovle S2, P3
cmp P2, P0
cmovg P1, P2

# n=5 model=out iset=I1 prefix14_class=2827
cmp P0, P1
cmovle S1, P0
cmovle P0, P1
cmovg S1, P1
cmp P2, P3
cmovg S2, P3
cmovle S2, P2
mov S0, P0
cmovg P3, P2
cmp P0, P3
cmovle P0, P3
cmovle P3, S0
cmp S2, S1
cmovg P1, S2

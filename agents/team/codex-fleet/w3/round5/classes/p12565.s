# n=5 model=out iset=I1 prefix14_class=12565
cmp P2, P3
cmovg S2, P3
cmovg P3, P2
cmovg P2, S2
cmp P0, P1
cmovle S2, P1
cmovle P1, P0
cmovle P0, S2
mov S0, P3
cmp P2, P1
cmovle S2, P1
cmovle P1, P2
cmovle P2, S2
cmp S0, P0

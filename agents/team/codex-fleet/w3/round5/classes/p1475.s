# n=5 model=out iset=I1 prefix14_class=1475
mov S1, P2
mov S0, P0
cmp P0, P3
cmovg S0, P3
cmovg P3, P0
cmp P2, P1
cmovle S1, P1
cmovle P1, P2
cmp S1, P3
cmovg P0, S1
cmovle P0, P3
mov P0, P1
cmovg S1, P3
cmp S0, P1

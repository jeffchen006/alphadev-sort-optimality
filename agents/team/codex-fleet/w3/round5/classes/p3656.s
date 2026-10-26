# n=5 model=out iset=I1 prefix14_class=3656
mov S0, P0
cmp P1, P2
mov S1, P1
cmovle P1, P2
cmovle P2, S1
cmp P3, P0
mov S1, P2
cmovle S0, P3
cmovle P3, P0
cmp S0, P2
cmovle S1, S0
cmovg P2, S0
cmp P3, P1
cmovg S1, P1

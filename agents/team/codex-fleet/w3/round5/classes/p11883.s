# n=5 model=out iset=I1 prefix14_class=11883
mov S1, P1
cmp P2, P3
cmovg S0, P3
cmovg P3, P2
cmovg P2, S0
cmp S1, P0
cmovle P1, P0
cmovg S1, P0
mov P0, P1
cmp P0, P3
cmovle P0, P3
cmovle P3, P1
cmp P2, S1
cmovle S2, P2

# n=5 model=out iset=I1 prefix14_class=3473
cmp P1, P3
mov S1, P1
cmovg P1, P3
mov S0, P0
cmovle S1, P3
cmp S0, P2
cmovle P0, P2
cmovle P2, S0
cmovge S0, P2
cmp P1, P2
cmovg S0, P1
cmovg P1, P2
cmp S1, P0
cmovle P1, P0

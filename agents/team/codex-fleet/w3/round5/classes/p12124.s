# n=5 model=out iset=I1 prefix14_class=12124
cmp P3, P1
mov S0, P1
cmovle P1, P3
mov S1, P0
cmovg S0, P3
cmp P2, S1
cmovle P0, P2
cmovg S1, P2
cmp P0, P1
cmovg P2, P1
cmovge P1, P0
cmovg P0, P2
cmp S1, S0
cmovle P2, S1

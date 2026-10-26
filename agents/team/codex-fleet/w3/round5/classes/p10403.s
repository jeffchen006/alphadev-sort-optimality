# n=5 model=out iset=I1 prefix14_class=10403
cmp P3, P2
cmovg S1, P3
cmovg P3, P2
cmovg P2, S1
mov S0, P1
cmp S0, P0
cmovle P1, P0
cmovg S0, P0
mov S2, P1
cmp P2, S2
cmovg S2, P2
cmovle P1, P2
cmp S0, P3
cmovge S2, P3

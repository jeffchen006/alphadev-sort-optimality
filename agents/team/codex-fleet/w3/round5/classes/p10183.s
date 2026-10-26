# n=5 model=out iset=I1 prefix14_class=10183
mov S0, P1
mov S1, P3
cmp S0, P2
cmovle P1, P2
cmovle P2, S0
cmp P3, P0
cmovle P3, P0
cmovg S1, P0
mov S0, S1
cmp P1, P3
cmovg P0, P1
cmovg P1, P3
cmovg P3, P0
cmp S1, P2

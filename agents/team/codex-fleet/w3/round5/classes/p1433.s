# n=5 model=out iset=I1 prefix14_class=1433
mov S2, P0
mov S0, P1
cmp P0, P3
cmovge S2, P3
cmovge P3, P0
cmp P2, S0
cmovg P1, P2
cmovg P2, S0
cmp P1, P3
mov S0, P1
cmovg S0, P3
cmovle P1, P3
cmp S2, P2
cmovg P3, S0

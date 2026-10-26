# n=5 model=out iset=I1 prefix14_class=5398
mov S2, P2
cmp P3, P2
cmovge S2, P3
mov S0, P1
cmovge P3, P2
cmp P1, P0
cmovle P1, P0
mov S1, P1
cmovle P0, S0
cmp P0, P3
cmovge S0, P0
cmovg P0, P3
cmovg P3, S0
cmp S2, S1

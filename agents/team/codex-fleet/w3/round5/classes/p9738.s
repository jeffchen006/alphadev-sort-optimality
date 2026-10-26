# n=5 model=out iset=I1 prefix14_class=9738
mov S0, P2
mov S1, P1
cmp S0, P3
cmovg P2, P3
cmovge P3, S0
cmp P0, S1
cmovle P1, P0
cmovle P0, S1
mov S0, P1
cmp P3, P0
cmovge S2, P3
cmovg P3, P0
cmovg P0, S2
mov P0, P3

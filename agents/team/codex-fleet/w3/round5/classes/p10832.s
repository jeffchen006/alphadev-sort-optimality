# n=5 model=out iset=I1 prefix14_class=10832
mov S2, P2
mov S0, P1
cmp S2, P3
cmovg P2, P3
cmovle S2, P3
cmp P0, P1
cmovge S0, P0
cmovg P0, P1
cmp S2, S0
cmovge P1, S2
cmovge S2, S0
cmovge S0, P1
cmp P2, P0
cmovle P1, P0

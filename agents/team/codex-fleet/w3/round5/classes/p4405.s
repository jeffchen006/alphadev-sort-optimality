# n=5 model=out iset=I1 prefix14_class=4405
mov S2, P1
cmp P0, S2
cmovg S2, P0
mov S0, P2
cmovg P0, P1
cmp P2, P3
cmovg S0, P3
cmovle P2, P3
cmovge P3, P2
cmp S2, P3
cmovg P3, S2
cmovge S2, P2
cmp S0, P0
cmovge S1, S0

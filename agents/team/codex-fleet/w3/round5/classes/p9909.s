# n=5 model=out iset=I1 prefix14_class=9909
cmp P1, P0
cmovg S1, P1
mov S2, P3
cmovge P1, P0
cmovg P0, S1
cmp P2, S2
cmovle P3, P2
mov S0, P0
cmovge S2, P2
cmp S2, P0
mov P2, P3
cmovg S0, S2
cmovle P0, S2
cmp P2, P1

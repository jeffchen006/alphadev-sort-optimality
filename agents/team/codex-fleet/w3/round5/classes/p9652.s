# n=5 model=out iset=I1 prefix14_class=9652
mov S1, P2
cmp P2, P3
cmovle P2, P3
cmovge S1, P3
mov S0, P1
cmp P1, P0
cmovge P1, P0
cmovle S0, P0
cmp S0, P2
mov S2, S0
cmovle S0, P2
cmovg S2, P2
cmp P1, S1
cmovg P2, P1

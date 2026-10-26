# n=5 model=out iset=I1 prefix14_class=7901
cmp P2, P1
mov S1, P2
cmovle P2, P1
cmovge S1, P1
mov S0, P0
cmp P3, P0
cmovge P0, P3
cmovle S0, P3
mov S2, P2
cmp S0, S1
cmovge P3, S0
cmovg S0, S1
cmovg S1, P3
cmp S2, P0

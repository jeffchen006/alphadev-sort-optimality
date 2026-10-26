# n=5 model=out iset=I1 prefix14_class=1437
mov S0, P3
mov S1, P2
cmp S1, P1
cmovg S1, P1
cmovge P1, P2
cmp P0, P3
cmovg P3, P0
cmovg P0, S0
cmovg S0, P3
cmp P3, P1
cmovle S0, P1
cmovg P3, P1
cmp S1, P0
cmovge S0, P0

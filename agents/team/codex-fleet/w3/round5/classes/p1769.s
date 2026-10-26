# n=5 model=out iset=I1 prefix14_class=1769
mov S2, P2
cmp P3, P2
mov S1, P0
cmovg P2, P3
cmovg P3, S2
cmp S1, P1
cmovge S1, P1
cmovle P0, P1
mov S0, P0
cmp S0, P2
cmovle S0, P2
cmovg P0, P2
cmp S1, P3
cmovge P1, P3

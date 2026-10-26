# n=5 model=out iset=I1 prefix14_class=7022
mov S2, P0
cmp P3, P0
cmovle P0, P3
cmovg S2, P3
cmovge P3, P0
cmp P2, P1
cmovle S0, P1
cmovg S0, P2
cmovge P2, P1
cmp P3, P2
cmovg P3, P2
cmovg P2, P0
cmp S2, S0
cmovge S1, S0

# n=5 model=out iset=I1 prefix14_class=12956
cmp P1, P0
cmovle S0, P0
cmovle P0, P1
cmovg S0, P1
cmp P2, P3
cmovge P1, P3
cmovge P3, P2
cmovg P2, P1
mov S2, P0
cmp P0, P2
cmovge S2, P2
cmovle P0, P2
mov S2, S0
cmp S0, P3

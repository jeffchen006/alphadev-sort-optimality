# n=5 model=out iset=I1 prefix14_class=9610
cmp P0, P1
cmovle S0, P0
cmovge S0, P1
cmovge P1, P0
cmp P2, P3
mov S1, P1
cmovg P0, P3
cmovge P3, P2
cmovg P2, P0
cmp S1, P3
cmovg S1, P3
cmovg P3, P1
cmp S0, P2
cmovle P1, S0

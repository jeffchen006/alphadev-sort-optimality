# n=5 model=out iset=I1 prefix14_class=352
cmp P1, P3
cmovg S1, P1
cmovg P1, P3
mov S0, P0
cmovle S1, P3
cmovg P3, S1
cmp S0, P2
cmovge P0, P2
cmovg P2, S0
mov S2, P0
cmp S2, P1
cmovle P0, P1
cmovge S2, P1
cmp P2, S1

# n=5 model=out iset=I1 prefix14_class=5949
cmp P0, P3
cmovge S0, P3
mov S1, P2
cmovle S0, P0
cmovg P3, P0
cmp S1, P1
mov S2, P3
cmovle P2, P1
cmovg S1, P1
cmp S2, P2
cmovge P3, P2
cmovle S2, P2
cmovle P2, P3
mov S2, S1

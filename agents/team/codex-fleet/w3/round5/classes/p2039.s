# n=5 model=out iset=I1 prefix14_class=2039
mov S2, P0
cmp P3, P1
mov S0, P1
cmovle S0, P3
cmovg P1, P3
cmp P2, S2
cmovge P0, P2
cmovge P2, S2
mov S1, P0
cmp S1, P1
cmovg S1, P1
cmovle P0, P1
cmp P2, S0
cmovle P3, P2

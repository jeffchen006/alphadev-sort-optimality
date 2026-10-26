# n=5 model=out iset=I1 prefix14_class=8405
cmp P1, P2
cmovle S2, P1
mov S1, P0
cmovg S2, P2
cmovg P2, P1
cmp P3, S1
cmovle P0, P3
cmovg S1, P3
cmp P2, S1
cmovge P3, S1
cmovg S1, P2
cmovg P2, P3
mov S0, P0
cmp S2, P0

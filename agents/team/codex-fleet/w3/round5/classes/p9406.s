# n=5 model=out iset=I1 prefix14_class=9406
mov S0, P0
cmp P3, P0
cmovg S0, P3
cmovge P3, P0
mov S2, P2
cmp P1, P2
cmovle S2, P1
cmovle P1, P2
cmp P3, S2
cmovg S1, P3
cmovg P3, S2
cmovg S2, S1
mov P0, S2
cmp S0, P1

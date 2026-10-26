# n=5 model=out iset=I1 prefix14_class=1474
cmp P2, P3
mov S0, P2
mov S1, P0
cmovg S0, P3
cmovg P3, P2
cmp S1, P1
cmovle P0, P1
cmovle P1, S1
cmp P0, P3
cmovg S2, P0
cmovge P0, P3
cmovle S2, P3
mov S2, P1
cmp S0, P1

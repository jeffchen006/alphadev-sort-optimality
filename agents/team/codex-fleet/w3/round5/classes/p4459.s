# n=5 model=out iset=I1 prefix14_class=4459
cmp P2, P3
cmovge S2, P3
cmovge P3, P2
cmovge P2, S2
mov S1, P0
cmp P1, P0
cmovle P0, P1
cmovg S1, P1
cmp S1, P3
cmovle S0, S1
cmovle S1, P3
cmovle P3, S0
mov P1, P3
mov S0, P2

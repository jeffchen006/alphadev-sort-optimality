# n=5 model=out iset=I1 prefix14_class=4552
mov S1, P0
cmp P0, P2
mov S2, P1
cmovle S1, P2
cmovg P0, P2
cmp P1, P3
cmovle P1, P3
mov P2, S1
cmovg S2, P3
cmp P1, P2
cmovge P2, P1
cmovle S1, P1
cmovg S0, S2
cmp P0, S2

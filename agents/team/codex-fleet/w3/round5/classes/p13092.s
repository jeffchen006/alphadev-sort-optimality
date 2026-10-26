# n=5 model=out iset=I1 prefix14_class=13092
cmp P2, P3
cmovle S1, P2
cmovg S1, P3
cmovle P2, P3
cmp P0, P1
cmovge P3, P0
cmovg P0, P1
mov S2, S1
cmovg P1, P3
mov S0, P1
cmp P0, S2
cmovle S2, P0
cmovle P0, S1
cmovg S1, P0

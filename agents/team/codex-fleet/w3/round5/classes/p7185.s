# n=5 model=out iset=I1 prefix14_class=7185
mov S1, P0
cmp P3, P2
cmovg S2, P2
cmovg P2, P3
cmovg P3, S2
cmp P0, P1
cmovge P0, P1
cmovle S1, P1
cmp P3, P0
mov S0, P2
cmovg P1, P3
cmovle P1, P0
cmovge P3, P0
mov P0, P1

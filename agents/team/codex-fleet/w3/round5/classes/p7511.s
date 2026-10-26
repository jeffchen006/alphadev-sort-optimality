# n=5 model=out iset=I1 prefix14_class=7511
cmp P3, P0
cmovle S0, P0
cmovle P0, P3
cmovg S0, P3
cmp P2, P1
mov P3, P1
cmovge P3, P2
cmovg P2, P1
cmp P0, P2
cmovle S2, P0
cmovle P0, P2
cmovle P2, S2
mov P1, P3
cmp P1, S0

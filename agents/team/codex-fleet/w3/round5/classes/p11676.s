# n=5 model=out iset=I1 prefix14_class=11676
mov S0, P1
cmp P1, P0
cmovle S0, P0
cmovge P1, P0
cmp P2, P3
cmovle P0, P3
mov S2, S0
cmovle P3, P2
cmovle P2, P0
cmp P2, S0
cmovle S0, P2
cmovg S2, P2
cmp P1, P3
cmovg P0, P3

# n=5 model=out iset=I1 prefix14_class=9810
mov S1, P3
cmp P1, S1
cmovg S1, P1
cmovg P1, P3
mov S2, P2
cmp P0, P2
cmovle P2, P0
mov S0, S1
cmovle P0, S2
cmp P0, S0
cmovg S1, P0
cmovge P0, S0
cmp P2, P1
cmovle S2, P1

# n=5 model=out iset=I1 prefix14_class=12693
cmp P3, P0
cmovg S1, P0
cmovg P0, P3
cmovg P3, S1
cmp P1, P2
mov S2, P3
cmovle S1, P2
cmovle P2, P1
cmovle P1, S1
cmp P2, P3
mov S0, P1
cmovg S2, P2
cmovge P2, P3
cmp P0, P1

# n=5 model=out iset=I1 prefix14_class=9410
mov S0, P0
cmp P1, S0
cmovg S0, P1
cmovge P1, P0
mov S1, P3
cmp P2, P3
cmovle S1, P2
cmovle P2, P3
cmp P1, S1
cmovg P0, P1
cmovg P1, S1
cmovg S1, P0
cmp P2, S0
cmovle P0, S0

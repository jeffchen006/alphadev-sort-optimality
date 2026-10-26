# n=5 model=out iset=I1 prefix14_class=11744
cmp P2, P3
cmovg S0, P2
cmovle S0, P3
cmovle P3, P2
cmp P1, P0
cmovge P2, P1
cmovg P1, P0
cmovge P0, P2
mov S1, P0
cmp P0, S0
cmovle P0, S0
cmovle S0, S1
mov S2, P1
cmovge S1, S0

# n=5 model=out iset=I1 prefix14_class=7406
cmp P1, P3
mov S0, P2
cmovle S2, P1
cmovle P1, P3
cmovle P3, S2
cmp P2, P0
cmovge S0, P0
mov S1, S0
cmovg P0, P2
cmp P3, S0
cmovg S0, P3
cmovge P3, S1
cmp P0, P1
cmovle S2, P1

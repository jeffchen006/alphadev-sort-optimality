# n=5 model=out iset=I1 prefix14_class=13931
cmp P0, P2
mov S2, P1
cmovle S1, P0
cmovle P0, P2
cmovle P2, S1
cmp P3, P1
mov S0, P0
cmovg S2, P3
cmovg P3, P1
cmp P0, S2
cmovle S0, S2
cmovge P0, S2
cmp P3, P2
cmovge S0, P2

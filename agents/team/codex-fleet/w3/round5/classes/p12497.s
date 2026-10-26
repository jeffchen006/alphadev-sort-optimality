# n=5 model=out iset=I1 prefix14_class=12497
mov S1, P0
cmp P1, P2
cmovle S0, P2
cmovle P2, P1
cmovle P1, S0
cmp P3, P0
cmovle P0, P3
mov S2, P0
cmovge S1, P3
cmp P0, P2
cmovle S2, P2
cmovg P0, P2
cmp P1, S1
cmovle P0, S1

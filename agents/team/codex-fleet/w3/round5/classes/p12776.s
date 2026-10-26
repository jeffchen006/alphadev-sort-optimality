# n=5 model=out iset=I1 prefix14_class=12776
cmp P0, P3
cmovge S2, P3
cmovg P3, P0
cmovg P0, S2
mov S1, P2
cmp P1, P2
cmovge S1, P1
cmovle P2, P1
cmp P2, P0
cmovle S0, P0
cmovle P0, P2
mov P1, S1
cmovle P2, S0
cmp P3, S1

# n=5 model=out iset=I1 prefix14_class=9961
cmp P1, P0
cmovge S2, P0
cmovle S2, P1
cmovg P0, P1
cmp P3, P2
mov S1, P3
cmovg P3, P2
mov P1, S2
cmovg P2, S1
cmp P0, P2
cmovge S0, P0
cmovge P0, P2
cmovg P2, S0
cmp P1, P3

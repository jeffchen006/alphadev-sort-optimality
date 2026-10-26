# n=5 model=out iset=I1 prefix14_class=8999
cmp P2, P1
cmovge S1, P1
cmovge P1, P2
cmovg P2, S1
cmp P0, P3
cmovle S2, P0
cmovge S2, P3
cmovle P0, P3
cmp P1, P0
cmovg P3, P0
cmovle P3, P1
cmovge P0, P1
cmovg P1, P3
mov S0, P2

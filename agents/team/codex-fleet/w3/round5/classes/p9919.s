# n=5 model=out iset=I1 prefix14_class=9919
cmp P3, P0
cmovge S0, P0
cmovge P0, P3
cmovle S0, P3
mov S1, P0
cmp P2, P1
mov P3, P2
cmovle P3, P1
cmovge P2, P1
cmp P3, S1
cmovle S1, P3
cmovge P0, P3
cmp P2, S0
cmovg P3, P2

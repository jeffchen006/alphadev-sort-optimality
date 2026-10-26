# n=5 model=out iset=I1 prefix14_class=5893
cmp P3, P0
cmovge S1, P0
mov S2, P1
cmovg P0, P3
cmovge P3, S1
cmp P2, S2
cmovle P1, P2
cmovle P2, S2
mov S0, P0
cmp P2, S0
cmovge P0, P2
cmovle S0, P2
cmp P3, P1
mov P2, S0

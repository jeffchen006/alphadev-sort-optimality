# n=5 model=out iset=I1 prefix14_class=1771
mov S2, P2
cmp P3, P2
cmovge P2, P3
cmovge P3, S2
mov S1, P2
cmp P0, P1
mov S0, P0
cmovle S0, P1
cmovge P0, P1
cmovle P1, P0
cmp P2, S0
cmovle S1, S0
cmovge P2, S0
mov S2, P2

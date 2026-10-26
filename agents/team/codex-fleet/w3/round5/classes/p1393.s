# n=5 model=out iset=I1 prefix14_class=1393
mov S1, P2
cmp P3, P2
cmovle S1, P3
cmovge P2, P3
mov S0, P0
cmp P0, P1
mov S2, P2
cmovg P0, P1
cmovg P1, S0
cmp P1, S2
cmovle S2, P1
cmovle P1, P2
mov P1, P0
cmp P1, S1

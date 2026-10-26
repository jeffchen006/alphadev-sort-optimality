# n=5 model=out iset=I1 prefix14_class=2033
mov S2, P0
mov S0, P3
cmp P2, S0
cmovge P3, P2
cmovg P2, S0
cmp P1, S2
cmovg P0, P1
cmovle S2, P1
cmovle P1, P0
cmp P0, P3
cmovg P1, P3
cmovge P3, P0
mov P3, P2
cmovg P0, P1

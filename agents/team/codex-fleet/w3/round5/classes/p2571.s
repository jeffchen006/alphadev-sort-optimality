# n=5 model=out iset=I1 prefix14_class=2571
cmp P2, P1
mov S0, P2
cmovg S0, P1
mov S1, P3
cmovge P1, P2
cmp P0, S1
cmovge P3, P0
cmovge P0, S1
cmp P1, P3
cmovg P2, P1
cmovle P2, P3
cmovge P1, P3
cmp P0, S0
cmovg P3, P0

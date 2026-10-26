# n=5 model=out iset=I1 prefix14_class=7680
cmp P0, P1
mov S0, P2
mov S2, P1
cmovle P1, P0
cmovle P0, S2
cmp P3, P2
cmovg S0, P3
cmovge P3, P2
cmp P3, P1
cmovge S2, P1
mov P2, S0
cmovge P1, P3
cmovge P3, S2
cmp P0, P2

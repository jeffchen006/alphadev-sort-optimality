# n=5 model=out iset=I1 prefix14_class=12062
mov S1, P3
cmp P1, P0
cmovge S0, P1
cmovge P1, P0
cmovge P0, S0
cmp P2, S1
cmovg S1, P2
cmovge P2, P3
cmp P1, P2
cmovle P3, P2
cmovle P2, P1
cmovg P3, P1
cmp P0, S1
cmovge S0, P0

# n=5 model=out iset=I1 prefix14_class=4096
mov S0, P2
mov S1, P0
cmp P3, P2
cmovge S0, P3
cmovle P2, P3
cmp P1, S1
cmovg P0, P1
cmovge P1, S1
cmp P2, P1
cmovg P3, P1
cmovge P1, P2
cmovg P2, P3
mov S2, S0
cmp P0, S2

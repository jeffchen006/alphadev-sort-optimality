# n=5 model=out iset=I1 prefix14_class=2208
mov S0, P2
cmp P1, P2
cmovge P2, P1
cmovg P1, S0
mov S0, P2
cmp P3, P0
cmovge S2, P0
cmovge P0, P3
cmovg P3, S2
cmp P2, P0
mov S1, P3
cmovle P2, P0
cmovle P0, S0
cmp P1, S1

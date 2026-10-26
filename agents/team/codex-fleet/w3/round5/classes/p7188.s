# n=5 model=out iset=I1 prefix14_class=7188
mov S0, P2
cmp P3, P0
cmovge S2, P0
cmovg P0, P3
cmovge P3, S2
cmp P1, P2
cmovge S0, P1
mov S1, S0
cmovle P2, P1
mov P1, P3
cmp P1, P2
cmovg P1, P2
cmovle P3, P2
cmovg P2, P3

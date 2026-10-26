# n=5 model=out iset=I1 prefix14_class=13782
cmp P1, P0
cmovge S1, P1
cmovge P1, P0
mov S0, P2
cmovg P0, S1
cmp P2, P3
cmovge S0, P3
cmovg P3, P2
cmp P0, P3
mov P2, P3
cmovle P3, P0
cmovge P2, P0
cmp P1, S0
cmovle P2, S0

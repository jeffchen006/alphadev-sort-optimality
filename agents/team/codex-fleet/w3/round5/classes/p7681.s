# n=5 model=out iset=I1 prefix14_class=7681
mov S0, P1
mov S1, P3
cmp P2, S0
cmovle P1, P2
cmovle P2, S0
cmp P0, S1
cmovge S1, P0
cmovge P0, P3
mov P3, S1
cmp P1, P0
cmovge S0, P0
cmovge P0, P1
cmovge P1, S0
cmp P2, S1

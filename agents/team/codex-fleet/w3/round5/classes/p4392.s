# n=5 model=out iset=I1 prefix14_class=4392
mov S2, P2
cmp P3, S2
cmovge P2, P3
cmovge P3, S2
cmp P0, P1
mov S0, P1
cmovge S0, P0
cmovle P1, P0
mov P0, S0
cmp P2, S0
cmovg S2, P3
cmovge P0, P2
cmovge P2, S0
cmp P3, P1

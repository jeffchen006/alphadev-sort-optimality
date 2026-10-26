# n=5 model=out iset=I1 prefix14_class=9589
cmp P0, P3
mov S2, P0
cmovle P0, P3
mov S1, P2
cmovle P3, S2
cmp P1, P2
mov S0, P0
cmovge S1, P1
cmovge P1, P2
cmp P0, S1
cmovge S0, S1
cmovg S1, P0
cmp P3, P1
cmovge P2, P1

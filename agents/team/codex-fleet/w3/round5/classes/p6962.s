# n=5 model=out iset=I1 prefix14_class=6962
cmp P1, P0
cmovg S0, P1
mov S1, P2
cmovg P1, P0
cmovg P0, S0
cmp P3, P2
cmovle P2, P3
cmovge S1, P3
cmp P0, S1
cmovge S0, P0
cmovge P0, S1
cmovg S1, S0
mov P3, P2
cmp P1, P2

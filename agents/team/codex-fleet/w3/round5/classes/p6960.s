# n=5 model=out iset=I1 prefix14_class=6960
cmp P1, P0
mov S1, P2
mov S0, P1
cmovg P1, P0
cmovge P0, S0
cmp P3, P2
cmovle P2, P3
cmovg S1, P3
cmp P0, S1
cmovge S0, P0
cmovge P0, S1
cmovge S1, S0
cmp P1, P2
cmovle P3, P2

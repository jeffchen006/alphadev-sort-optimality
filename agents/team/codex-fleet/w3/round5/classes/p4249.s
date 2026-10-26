# n=5 model=out iset=I1 prefix14_class=4249
mov S0, P3
cmp P3, P1
cmovge S0, P1
cmovge P1, P3
mov S1, P0
cmovg P3, S0
cmp P2, P0
cmovg S1, P2
cmovg P2, P0
cmp P2, S0
cmovg S0, P2
cmovle P3, P2
cmp P1, S1
cmovge P0, S1

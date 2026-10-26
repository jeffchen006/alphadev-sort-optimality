# n=5 model=out iset=I1 prefix14_class=970
mov S0, P3
cmp P1, P3
cmovle P3, P1
cmovg S0, P1
mov S2, S0
mov S1, P2
cmp P2, P0
cmovg P2, P0
cmovge P0, S1
cmp P0, S2
cmovge S0, P0
cmovg P0, S2
cmp P2, P3
mov S2, P3

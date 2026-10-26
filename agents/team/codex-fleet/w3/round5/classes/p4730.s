# n=5 model=out iset=I1 prefix14_class=4730
cmp P3, P1
mov S2, P3
cmovg S2, P1
mov S1, P0
cmovle P3, P1
cmp P2, S1
cmovg P0, P2
mov S0, S2
cmovge P2, S1
cmp P2, S0
cmovg S0, P2
cmovge P2, S2
cmp P0, P3
cmovg S2, S0

# n=5 model=out iset=I1 prefix14_class=7824
cmp P0, P3
mov S2, P0
cmovge P0, P3
cmovge P3, S2
cmp P2, P1
cmovg S2, P2
mov S0, P0
cmovge P2, P1
cmovg P1, S2
cmp P0, P2
cmovle P0, P2
cmovge S0, P2
cmp P1, P3
mov S0, P1

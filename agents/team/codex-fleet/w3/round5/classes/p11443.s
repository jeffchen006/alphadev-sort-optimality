# n=5 model=out iset=I1 prefix14_class=11443
mov S2, P2
cmp P0, P2
cmovle P2, P0
cmovge S2, P0
cmp P3, P1
cmovg S0, P1
cmovg P1, P3
cmovg P3, S0
cmp P3, P2
mov P0, P3
cmovge P0, P2
cmovle P3, P2
cmp P1, S2
cmovle P2, P1

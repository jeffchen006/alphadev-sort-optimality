# n=5 model=out iset=I1 prefix14_class=9613
cmp P0, P1
mov S0, P0
cmovg S0, P1
cmovg P1, P0
cmp P2, P3
cmovge P0, P3
cmovge P3, P2
cmovge P2, P0
mov S1, P1
cmp P1, P3
cmovge S1, P3
cmovg P3, P1
cmp P2, S0
cmovle P3, P2

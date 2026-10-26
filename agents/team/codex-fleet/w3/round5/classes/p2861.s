# n=5 model=out iset=I1 prefix14_class=2861
cmp P3, P1
mov S0, P1
cmovle P1, P3
cmovge S0, P3
cmp P0, P2
cmovge P3, P2
cmovg P2, P0
cmovg P0, P3
mov S2, S0
cmp P2, S2
cmovge S2, P2
cmovge P2, S0
mov S2, P1
mov S1, P2

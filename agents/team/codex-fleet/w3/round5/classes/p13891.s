# n=5 model=out iset=I1 prefix14_class=13891
mov S0, P2
cmp P2, P3
cmovg P2, P3
cmovg P3, S0
cmp P0, P1
cmovge S0, P1
cmovg P1, P0
cmovge P0, S0
cmp P1, P3
mov S2, P3
cmovge P3, P1
cmovge P1, S2
cmp P0, P2
cmovle P3, P0

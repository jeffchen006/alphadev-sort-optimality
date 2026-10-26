# n=5 model=out iset=I1 prefix14_class=5057
mov S2, P1
cmp P3, S2
cmovge P1, P3
cmovle S2, P3
mov S0, P2
cmp P0, P2
mov S1, S2
cmovle S0, P0
cmovge P2, P0
cmp S0, S1
cmovle S2, S0
cmovge S1, S0
cmp P2, P1
cmovg P3, P2

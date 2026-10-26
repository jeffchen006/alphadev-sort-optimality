# n=5 model=out iset=I1 prefix14_class=1767
mov S2, P2
mov S1, P3
cmp P0, P2
cmovg P2, P0
cmovge P0, S2
cmp S1, P1
cmovge S1, P1
cmovle P3, P1
mov S0, P3
cmp S0, P2
cmovle S0, P2
cmovge P3, P2
cmp P0, S1
cmovge P1, S1

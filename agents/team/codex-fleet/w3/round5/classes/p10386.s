# n=5 model=out iset=I1 prefix14_class=10386
cmp P3, P2
mov S2, P2
cmovg S2, P3
cmovge P3, P2
cmp P0, P1
mov S1, P1
cmovg S1, P0
mov S0, S1
cmovge P0, P1
cmp S1, S2
cmovge S1, S2
cmovle S0, S2
cmp P3, P0
cmovge P2, P0

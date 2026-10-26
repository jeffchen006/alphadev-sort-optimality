# n=5 model=out iset=I1 prefix14_class=7805
mov S0, P2
cmp S0, P3
cmovge P2, P3
cmovle S0, P3
cmp P0, P1
mov P3, P2
cmovge S1, P0
cmovge P0, P1
cmovge P1, S1
cmp P0, P3
cmovle P3, P0
cmovg P2, P0
mov S2, P2
cmp S0, P1

# n=5 model=out iset=I1 prefix14_class=10023
cmp P2, P3
mov S2, P3
cmovg S2, P2
cmovge P2, P3
cmp P0, P1
cmovge S1, P0
cmovg P0, P1
cmovge P1, S1
mov S0, S2
cmp S2, P1
cmovle S2, P1
cmovg S0, P1
mov P1, P2
cmp P0, P1

# n=5 model=out iset=I1 prefix14_class=13746
mov S2, P3
cmp P3, P2
cmovle S2, P2
cmovge P3, P2
cmp P0, P1
mov S0, P3
cmovge P2, P1
cmovg P1, P0
cmovg P0, P2
cmp S2, P1
cmovge S1, S2
cmovg S2, P1
cmovge P1, S1
cmp S0, P0

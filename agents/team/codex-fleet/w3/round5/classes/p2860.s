# n=5 model=out iset=I1 prefix14_class=2860
cmp P0, P2
mov S0, P2
cmovle S0, P0
cmovge P2, P0
cmp P3, P1
cmovle S2, P1
cmovge S2, P3
cmovg P3, P1
mov S1, P2
cmp S2, S1
cmovge S1, S2
mov P0, P3
cmovge S2, P2
mov S1, S2

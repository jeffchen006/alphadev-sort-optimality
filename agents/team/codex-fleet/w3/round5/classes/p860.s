# n=5 model=out iset=I1 prefix14_class=860
mov S1, P2
mov S0, P1
cmp P2, P0
cmovle S1, P0
cmovg P2, P0
cmovge P0, S1
cmp S0, P3
cmovg S0, P3
cmovge P3, P1
cmp P3, S1
cmovge P0, P3
cmovle S1, P3
mov S2, P2
mov P3, S1

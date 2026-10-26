# n=5 model=out iset=I1 prefix14_class=8605
cmp P1, P0
mov S2, P0
cmovg P0, P1
cmovle S2, P1
cmp P2, P3
cmovge S1, P3
cmovg P3, P2
cmovge P2, S1
mov S0, S2
mov S1, P3
cmp S1, P0
cmovg S1, P0
cmovg P0, P3
mov P0, S1

# n=5 model=out iset=I1 prefix14_class=8874
cmp P0, P1
cmovge S2, P1
cmovge P1, P0
mov S0, P2
cmovg P0, S2
cmp S0, P3
cmovge P2, P3
mov S1, P0
cmovg P3, S0
cmp P1, P3
cmovg S0, P1
cmovge P1, P3
cmovle S0, P3
cmp P0, P2

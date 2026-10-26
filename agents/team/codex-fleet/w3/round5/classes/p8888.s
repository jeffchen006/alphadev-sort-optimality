# n=5 model=out iset=I1 prefix14_class=8888
cmp P1, P2
cmovg S1, P1
cmovle S1, P2
cmovg P1, P2
mov S0, P0
cmp S0, P3
cmovg S0, P3
mov S2, S0
cmovge P3, P0
cmp S1, P3
cmovge P2, P3
cmovge P3, S1
cmovge S1, P2
cmp S0, P1

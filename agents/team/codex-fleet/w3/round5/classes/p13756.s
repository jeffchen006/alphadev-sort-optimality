# n=5 model=out iset=I1 prefix14_class=13756
cmp P1, P0
cmovg S1, P0
cmovg P0, P1
mov S0, P2
cmovle S1, P1
cmp P2, P3
cmovle S0, P3
cmovge P2, P3
cmp S0, P0
mov P1, P2
cmovge P3, S0
cmovge S0, P0
cmovge P0, P3
cmp P1, S1

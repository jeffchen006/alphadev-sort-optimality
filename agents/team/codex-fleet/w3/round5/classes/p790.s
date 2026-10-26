# n=5 model=out iset=I1 prefix14_class=790
mov S0, P3
cmp S0, P1
mov S1, P0
cmovg P3, P1
cmovle S0, P1
mov P1, P3
cmp P0, P2
cmovg P0, P2
cmovge P2, S1
cmovle S1, P2
cmp S1, S0
cmovge S1, S0
cmovg S0, P2
cmovge P2, S1

# n=5 model=out iset=I1 prefix14_class=798
mov S0, P0
mov S2, P1
cmp S2, P2
cmovle S2, P2
cmovge P1, P2
cmp P0, P3
cmovge P0, P3
cmovg P3, S0
mov P2, P0
cmp P3, S2
cmovge S0, P3
cmovge P3, S2
cmovge S2, S0
cmp P0, P1

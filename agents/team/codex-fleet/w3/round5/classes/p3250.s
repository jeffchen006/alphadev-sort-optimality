# n=5 model=out iset=I1 prefix14_class=3250
mov S0, P0
cmp P1, S0
cmovge P0, P1
cmovge P1, S0
cmp P3, P2
mov S0, P1
mov S1, P2
cmovge S1, P3
cmovg P3, P2
cmp P1, P3
cmovle S0, P3
cmovge P1, P3
mov P2, S0
cmp S1, P0

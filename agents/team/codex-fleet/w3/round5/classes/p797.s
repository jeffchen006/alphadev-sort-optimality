# n=5 model=out iset=I1 prefix14_class=797
mov S1, P1
cmp S1, P2
cmovg P1, P2
cmovle S1, P2
mov S0, P0
cmp P0, P3
cmovge P0, P3
cmovge P3, S0
cmp P3, S1
mov S0, P3
cmovge P3, S1
cmovge S1, S0
mov S0, P3
cmp P0, P1

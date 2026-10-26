# n=5 model=out iset=I1 prefix14_class=6152
mov S1, P0
mov S0, P2
cmp P1, S0
cmovge P2, P1
cmovge P1, S0
cmp S1, P3
cmovge P0, P3
cmovge P3, S1
cmp P2, P3
mov S1, P2
cmovle S1, P3
cmovge P2, P3
cmp P1, P0
cmovge P3, P1

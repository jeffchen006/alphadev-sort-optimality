# n=5 model=out iset=I1 prefix14_class=8627
cmp P2, P0
mov S0, P0
cmovge P0, P2
cmovle S0, P2
cmp P1, P3
mov P2, P1
cmovg P1, P3
mov S1, S0
cmovge P3, P2
cmp P3, P0
cmovg P2, P0
cmovge P0, P3
cmovg P3, P2
cmp S1, P1

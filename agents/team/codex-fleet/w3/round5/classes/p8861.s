# n=5 model=out iset=I1 prefix14_class=8861
mov S0, P2
cmp P3, P2
cmovle S0, P3
cmovg P2, P3
cmp P1, P0
cmovge P3, P0
cmovge P0, P1
cmovg P1, P3
mov S2, P2
cmp P0, P2
cmovge P2, P0
cmovge P0, S2
mov S2, P0
mov S1, S0

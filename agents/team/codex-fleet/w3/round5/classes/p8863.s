# n=5 model=out iset=I1 prefix14_class=8863
cmp P3, P2
cmovg S2, P2
cmovle S2, P3
cmovg P2, P3
cmp P1, P0
cmovge P3, P0
cmovge P0, P1
cmovge P1, P3
mov S0, P2
cmp P0, P2
cmovge P2, P0
cmovge P0, S0
mov P2, P0
mov S1, P1

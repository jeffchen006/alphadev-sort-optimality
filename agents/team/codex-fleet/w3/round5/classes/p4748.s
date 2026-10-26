# n=5 model=out iset=I1 prefix14_class=4748
cmp P0, P2
cmovge S2, P0
cmovle S2, P2
cmovge P0, P2
mov P2, P1
cmp P3, P1
cmovg P1, P3
mov S1, P0
cmovge P3, P2
cmp P3, P0
cmovg P0, P3
mov S0, P0
cmovg P3, S1
mov P3, P1

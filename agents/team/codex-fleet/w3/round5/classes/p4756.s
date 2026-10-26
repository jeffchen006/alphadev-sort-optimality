# n=5 model=out iset=I1 prefix14_class=4756
cmp P1, P0
cmovg S2, P1
cmovge P1, P0
cmovle S2, P0
cmp P2, P3
mov S0, P3
cmovge S0, P2
cmovge P2, P3
mov P0, P1
cmp P2, P1
cmovge P0, P2
cmovge P2, P1
mov P3, P0
mov P2, S2

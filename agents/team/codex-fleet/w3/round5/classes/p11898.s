# n=5 model=out iset=I1 prefix14_class=11898
cmp P0, P3
mov S0, P3
cmovge P3, P0
cmovge P0, S0
cmp P1, P2
cmovg S2, P2
cmovle S2, P1
cmovg P2, P1
cmp P3, P2
mov S1, S2
cmovge P1, P3
cmovge P3, P2
cmovg P2, P1
mov P2, P3

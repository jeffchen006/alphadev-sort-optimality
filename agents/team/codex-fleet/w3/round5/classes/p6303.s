# n=5 model=out iset=I1 prefix14_class=6303
mov S2, P0
cmp P3, P0
cmovle S2, P3
cmovge P0, P3
cmp P2, P1
mov S0, P0
cmovg S1, P2
cmovge P2, P1
mov P3, P2
cmovg P1, S1
cmp P1, S0
cmovge P0, P1
cmovge P1, S0
cmp P2, S2

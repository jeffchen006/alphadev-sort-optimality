# n=5 model=out iset=I1 prefix14_class=1358
cmp P3, P2
cmovg S1, P2
cmovle S1, P3
cmovge P2, P3
cmp P0, P1
cmovg S0, P1
cmovge P1, P0
cmovle S0, P0
cmp P1, P2
cmovge P3, P2
cmovge P2, P1
cmovg P1, P3
mov P2, S0
mov P0, P1

# n=5 model=out iset=I1 prefix14_class=833
cmp P0, P3
mov S2, P0
cmovle S2, P3
cmovge P0, P3
mov P3, S2
cmp P2, P1
cmovle S0, P2
cmovg S0, P1
cmovge P1, P2
cmp P1, S2
cmovle S2, P1
mov P2, S0
cmovg P3, P1
mov P1, S2

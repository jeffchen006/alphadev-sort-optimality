# n=5 model=out iset=I1 prefix14_class=10288
cmp P3, P1
mov S2, P3
cmovle P3, P1
cmovg S2, P1
cmp P0, P2
mov S0, P3
cmovge P1, P2
cmovge P2, P0
cmovge P0, P1
cmp P2, P3
cmovle S0, P2
cmovg P3, P2
cmp P0, S2
cmovge P3, S2

# n=5 model=out iset=I1 prefix14_class=531
cmp P1, P3
cmovg S1, P1
cmovg P1, P3
mov S2, P2
cmovg P3, S1
cmp P2, P0
cmovge P2, P0
cmovg P0, S2
mov S0, P1
cmp P2, P1
cmovle S0, P2
cmovle P2, P1
mov P1, P2
cmp P3, P0

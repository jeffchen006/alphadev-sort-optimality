# n=5 model=out iset=I1 prefix14_class=6290
cmp P0, P1
mov S0, P1
cmovle S0, P0
mov S2, P3
cmovg P1, P0
cmp P2, P3
cmovg S2, P2
cmovg P2, P3
mov P0, P1
cmp P0, S2
cmovle P0, S2
cmovle S2, P1
cmp P2, S0
cmovge P1, P2

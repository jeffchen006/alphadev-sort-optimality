# n=5 model=out iset=I1 prefix14_class=4398
mov S2, P0
cmp P1, P0
cmovge P0, P1
cmovge P1, S2
cmp P2, P3
cmovle S0, P2
cmovg S0, P3
cmovle P2, P3
cmp P0, P2
cmovg P3, P2
cmovg P2, P0
cmovg P0, P3
mov P2, P1
cmp P2, S0

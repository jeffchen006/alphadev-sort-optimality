# n=5 model=out iset=I1 prefix14_class=4734
cmp P3, P2
cmovg S0, P2
cmovle S0, P3
mov S2, S0
cmovle P3, P2
cmp P1, P0
mov P2, P0
cmovge P0, P1
cmovge P1, P2
cmp P1, S2
cmovg S2, P1
cmovg P1, S0
cmp P3, P0
cmovg S0, P3

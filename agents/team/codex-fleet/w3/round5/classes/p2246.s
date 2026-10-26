# n=5 model=out iset=I1 prefix14_class=2246
cmp P0, P2
cmovle S0, P2
mov S1, P3
cmovg S0, P0
cmovg P0, P2
cmp P1, P3
cmovge P3, P1
mov P2, P3
cmovge P1, S1
cmp P3, S0
cmovle P3, S0
cmovle S0, P2
cmp P1, P0
cmovle P3, P1
